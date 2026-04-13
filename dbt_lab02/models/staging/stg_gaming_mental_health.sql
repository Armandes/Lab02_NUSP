with source as (
    select * from {{ source('silver', 'gaming_mental_health') }}
),

staging as (
    select
        -- Identificação
        {{ dbt_utils.generate_surrogate_key([
            'age', 'gender', 'income',
            'anxiety_score', 'depression_score',
            'daily_gaming_hours', 'sleep_hours',
            'addiction_level', 'happiness_score'
        ]) }} as player_id,

        -- Perfil do jogador
        age,
        gender,
        income,
        bmi,

        -- Hábitos
        daily_gaming_hours,
        weekly_sessions,
        years_gaming,
        sleep_hours,
        caffeine_intake,
        exercise_hours,
        weekend_gaming_hours,
        screen_time_total,
        streaming_hours,

        -- Comportamento
        multiplayer_ratio,
        toxic_exposure,
        violent_games_ratio,
        mobile_gaming_ratio,
        night_gaming_ratio,
        esports_interest,
        headset_usage,
        microtransactions_spending,
        competitive_rank,
        internet_quality,

        -- Social
        friends_gaming_count,
        online_friends,
        social_interaction_score,
        relationship_satisfaction,
        loneliness_score,
        parental_supervision,

        -- Saúde mental
        stress_level,
        anxiety_score,
        depression_score,
        addiction_level,
        happiness_score,
        aggression_score,
        academic_performance,
        work_productivity,
        eye_strain_score,
        back_pain_score

    from source
)

select * from staging