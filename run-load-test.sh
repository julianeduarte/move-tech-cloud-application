#!/bin/bash

echo "🚀 Iniciando teste de carga com K6..."

# Verifica se o k6 está instalado
if ! command -v k6 &> /dev/null; then
    echo "❌ O K6 não está instalado. Instale-o antes de continuar."
    exit 1
fi

# Executa o teste de carga
k6 run load/k6/load-test.js

echo "✅ Teste de carga finalizado com sucesso!"