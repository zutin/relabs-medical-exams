import { displayExamInfo } from './examInfo.js';
const endpoint = 'http://localhost:3000/';

export function getExamDetails(exam_token) {
  const container = document.getElementById("exam-container");
  const info = document.getElementById("exam-details");
  const title = document.getElementById("exam-token");
  info.innerHTML = '';
  container.classList.remove('hidden');

  fetch(endpoint + 'test/' + exam_token)
    .then((response) => response.json())
    .then((data) => {
      let examData = data;

      title.innerHTML = `Exame #${examData.result_token}
      <p>${data.result_date}</p>`;
      
      displayExamInfo('dados', examData);

      document.getElementById('dados-btn').addEventListener('click', () => {
        displayExamInfo('dados', examData);
      });

      document.getElementById('doutor-btn').addEventListener('click', () => {
        displayExamInfo('doutor', examData);
      });

      document.getElementById('resultados-btn').addEventListener('click', () => {
        displayExamInfo('amostras', examData);
      });
    });
}
