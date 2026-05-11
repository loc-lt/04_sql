-- Procedure-based report snapshot

CREATE TABLE IF NOT EXISTS report_snapshot (
    snapshot_id BIGSERIAL PRIMARY KEY,
    report_name VARCHAR(100) NOT NULL,
    generated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    params JSONB NOT NULL,
    payload JSONB NOT NULL
);

CREATE OR REPLACE PROCEDURE sp_snapshot_order_status_report(
    p_start_date DATE,
    p_end_date DATE,
    p_seller_id INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_payload JSONB;
BEGIN
    SELECT COALESCE(
        JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'status', status,
                'order_count', order_count,
                'revenue', revenue,
                'revenue_share_pct', revenue_share_pct
            )
            ORDER BY revenue DESC
        ),
        '[]'::JSONB
    )
    INTO v_payload
    FROM fn_order_status_summary_report(p_start_date, p_end_date, p_seller_id);

    INSERT INTO report_snapshot (report_name, params, payload)
    VALUES (
        'order_status_summary',
        JSONB_BUILD_OBJECT(
            'start_date', p_start_date,
            'end_date', p_end_date,
            'seller_id', p_seller_id
        ),
        v_payload
    );
END;
$$;
