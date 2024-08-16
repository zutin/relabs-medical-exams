const api = "http://127.0.0.1:3000/";

export function uploadFile() {
  const fileInput = document.getElementById('fileInput');
  const file = fileInput.files[0];

  if (file) {
    const formData = new FormData();
    formData.append('file', file);

    fetch(api + 'import', {
      method: 'POST',
      body: formData,
    })
    .then((response) => {
      if (response.ok) {
        return console.log(response);
      } else {
        alert('Envie somente arquivos .csv');
        throw new Error('Falha no envio do arquivo');
      }
    })
      .then((data) => {
        console.log(data);
        fileInput.files = null;
        location.reload();
      })
      .catch((error) => {
        console.error('Error:', error);
      });
  } else {
    alert('Você precisa selecionar um arquivo para ser enviado.')
  }
}