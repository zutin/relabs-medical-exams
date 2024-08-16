export function handleFileInput(event) {
  const fileName = event.target.files[0]?.name || 'Selecione um arquivo';
  document.getElementById('fileLabel').textContent = fileName;
}
