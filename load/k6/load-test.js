import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 }, // Simula subida para 20 usuários
    { duration: '1m', target: 50 },  // Mantém 50 usuários
    { duration: '10s', target: 0 },  // Desacelera/Encerra
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% das requisições devem responder em menos de 500ms
    http_req_failed: ['rate<0.01'],   // Menos de 1% de erro
  },
};

export default function () {
  // Ajuste a URL para o seu endpoint ou IP público da VM na Magalu Cloud
  const res = http.get('http://localhost/health'); 
  
  check(res, {
    'status é 200': (r) => r.status === 200,
  });
  
  sleep(1);
}