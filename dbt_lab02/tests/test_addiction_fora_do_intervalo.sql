-- Teste singular: busca jogadores com addiction_level fora do intervalo 0-10
-- Se retornar alguma linha, o teste falha

select *
from {{ ref('stg_gaming_mental_health') }}
where addiction_level < 0
   or addiction_level > 10