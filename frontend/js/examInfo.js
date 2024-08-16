export function displayExamInfo(type, data) {
  const info = document.getElementById("exam-details");
  info.innerHTML = '';

  if (type === 'dados') {
    info.innerHTML = `
      <p>CPF: ${data.cpf}</p>
      <p>Nome: ${data.name}</p>
      <p>Email: ${data.email}</p>
      <p>Data de Nascimento: ${data.birthday}</p>
    `;
  } else if (type === 'doutor') {
    info.innerHTML = `
      <p>CRM: ${data.doctor.crm}</p>
      <p>Estado do CRM: ${data.doctor.crm_state}</p>
      <p>Nome: ${data.doctor.name}</p>
      <p>Email: ${data.doctor.email}</p>
    `;
  } else if (type === 'amostras') {
    info.innerHTML = `
      <p>Amostras coletadas:</p>
    ` + data.tests.map((test) => {
      return `<p>${test.type}: ${test.result} - Limite entre ${test.limits}</p>`;
    }).join('');
  }
}
