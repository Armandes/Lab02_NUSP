-- Teste singular: busca jogadores com horas de jogo acima de 24h
-- Se retornar alguma linha, o teste falha

select *
from {{ ref('stg_gaming_mental_health') }}
where daily_gaming_hours > 24