import '../assets/stylesheets/application.css'
import { uploadFile } from './uploadFile.js'
import { handleFileInput } from './fileInputHandler.js'
import { getExamDetails } from './examDetails.js'

const endpoint = "http://127.0.0.1:3000/";
let examsData = [];
let filteredData = [];
let currentPage = 1;
const maxPageButtons = 5;
const itemsPerPage = 5;

function displayData(data, filter = false) {
  const tableBody = document.getElementById("exam-list");
  tableBody.innerHTML='';

  if (filter && filteredData.length > 0) {
    data = filteredData;
  }

  const start = (currentPage - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  const paginatedData = data.slice(start, end);

  paginatedData.forEach((item) => {
    const row = document.createElement("div");
    row.classList.add('exam-row');

    row.innerHTML = `
      <div style="text-align: center; max-width: 50%;">
        <p style="font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${item.result_token}</p>
        <p style="font-size: 0.775rem; font-weight: 400;">${item.result_date}</p>
      </div>
      <div style="text-align: center; flex-grow: 1; max-width: 75%;">
        <p style="font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${item.name}</p>
        <p style="font-size: 0.775rem; font-weight: 400;">${item.doctor.name}</p>
      </div>
    `;

    row.addEventListener('click', () => {
      getExamDetails(item.result_token);
    });

    tableBody.appendChild(row);
  });

  renderPaginationControls(data.length);
}

function renderPaginationControls(totalItems) {
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const paginationControls = document.getElementById("pagination-controls");

  paginationControls.innerHTML = '';

  let startPage = Math.max(1, currentPage - Math.floor(maxPageButtons / 2));
  let endPage = Math.min(totalPages, startPage + maxPageButtons - 1);

  if (endPage - startPage < maxPageButtons - 1) {
    startPage = Math.max(1, endPage - maxPageButtons + 1);
  }

  if (currentPage > 1) {
    const prevButton = document.createElement("button");
    prevButton.classList.add('nav-button');
    prevButton.textContent = "«";
    prevButton.addEventListener('click', () => {
      currentPage--;
      displayData(examsData, filteredData.length > 0);
    });
    paginationControls.appendChild(prevButton);
  }

  for (let i = startPage; i <= endPage; i++) {
    const pageButton = document.createElement("button");
    pageButton.textContent = i;
    pageButton.className = i === currentPage ? 'active-page' : 'nav-button';
    pageButton.addEventListener('click', () => {
      currentPage = i;
      displayData(examsData, filteredData.length > 0);
    });
    paginationControls.appendChild(pageButton);
  }

  if (currentPage < totalPages) {
    const nextButton = document.createElement("button");
    nextButton.classList.add('nav-button');
    nextButton.textContent = "»";
    nextButton.addEventListener('click', () => {
      currentPage++;
      displayData(examsData, filteredData.length > 0);
    });
    paginationControls.appendChild(nextButton);
  }
}

function search(examsData) {
  const input = document.getElementById('search-query');
  
  if(input.value.length >= 2){
    let query = input.value.toLowerCase().trim();
    currentPage = 1;

    filteredData = examsData.filter((item) => {
      const patientMatch = item.name.toLowerCase().includes(query);
      const doctorMatch = item.doctor.name.toLowerCase().includes(query);
      const tokenMatch = item.result_token.toLowerCase().includes(query);
      return patientMatch || doctorMatch || tokenMatch;
    });
  
    displayData(filteredData, true);
  } else {
    filteredData = [];
    displayData(examsData);
  }
}

document.getElementById('fileInput').addEventListener('change', handleFileInput);

document.addEventListener('DOMContentLoaded', () => {
  const uploadButton = document.getElementById('sendFile');
  const searchQuery = document.getElementById('search-query');
  const closeExamButton = document.getElementById('exam-close');

  if (uploadButton) {
    uploadButton.addEventListener('click', uploadFile);
  }

  if (searchQuery) {
    searchQuery.addEventListener('input', () => search(examsData));
  }

  if (closeExamButton) {
    closeExamButton.addEventListener('click', () => {
      document.getElementById("exam-container").classList.add('hidden');
    });
  }

  fetch(endpoint + 'tests')
    .then((response) => response.json())
    .then((data) => {
      examsData = data;
      displayData(data);
    })
    .catch(function (error) {
      console.log(error);
    });
});