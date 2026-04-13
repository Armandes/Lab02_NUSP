with staging as (
    select * from {{ ref('stg_gaming_mental_health') }}
),

final as (
    select
        player_id,
        gender,
        age,
        income,
        bmi,

        -- Hábitos
        daily_gaming_hours,
        weekly_sessions,
        years_gaming,
        sleep_hours,
        exercise_hours,

        -- Social
        online_friends,
        friends_gaming_count,
        loneliness_score,
        social_interaction_score

    from staging
)

select * from final