#!/bin/bash
echo "🚀 Iniciando teste de carga com K6..."

# Verifica se o k6 está instalado
if ! command -v k6 &> /dev/null; then
    echo "❌ O K6 não está instalado. Instale-o antes de continuar."
    exit 1
fi

# Alvo do teste: use BASE_URL=http://<IP> ./run-load-test.sh para apontar
# para a aplicação em produção. Sem isso, cai no padrão http://localhost.
BASE_URL="${BASE_URL:-http://localhost}"
echo "🎯 Alvo do teste: $BASE_URL"

# Executa o teste de carga, repassando BASE_URL para o script k6
k6 run -e BASE_URL="$BASE_URL" load/k6/load-test.js

echo "✅ Teste de carga finalizado com sucesso!"