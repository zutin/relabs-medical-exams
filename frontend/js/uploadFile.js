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
      .then((response) => console.log(response)) // aqui retorna success true e status 200
      .then((data) => {
        console.log(data);
        fileInput.files = null;
      })
      .catch((error) => {
        console.error('Error:', error);
      });
  } else {
    alert('Você precisa selecionar um arquivo para ser enviado.')
  }
}