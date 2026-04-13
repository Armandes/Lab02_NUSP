with staging as (
    select * from {{ ref('stg_gaming_mental_health') }}
),

final as (
    select
        player_id,

        -- Classificação de horas de jogo
        {{ classificar_horas_jogo('daily_gaming_hours') }} as faixa_horas_jogo,

        -- Métricas de saúde mental
        stress_level,
        anxiety_score,
        depression_score,
        addiction_level,
        happiness_score,
        aggression_score,
        academic_performance,
        work_productivity,
        eye_strain_score,
        back_pain_score,

        -- Contexto
        gender,
        age,
        sleep_hours,
        daily_gaming_hours,
        toxic_exposure

    from staging
)

select * from final