import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "avatarImg", "personAvatar", "activateWebcam", "captureImage", "captureCanvas", "captureVideo"
  ]

  connect() {
    this.webcamActive = false;
    this.captureText = "Capture from camera";
    this.stopText = "Cancel capture";
    this.activateWebcamTarget.value = this.captureText;
    this.captureVideoTarget.style.display = "none";
    this.captureImageTarget.style.display = "none";
    this.avatarImgTarget.style.display = "inherit";
    this.personAvatarTarget.addEventListener("change", this.handleFileChange.bind(this));
    this.activateWebcamTarget.addEventListener("click", this.toggleWebcam.bind(this));
    this.captureImageTarget.addEventListener("click", this.capturePhoto.bind(this));
  }

  handleFileChange(ev) {
    const reader = new FileReader();
    reader.addEventListener("load", ev => {
      this.avatarImgTarget.src = ev.target.result;
    });
    reader.readAsDataURL(ev.target.files[0]);
    this.webcamActive = true;
    this.activateWebcamTarget.click();
  }

  toggleWebcam(ev) {
    this.webcamActive = !this.webcamActive;
    if (this.webcamActive) {
      this.activateWebcamTarget.value = this.stopText;
      navigator.mediaDevices
        .getUserMedia({ video: true, audio: false })
        .then(stream => {
          this.captureVideoTarget.srcObject = stream;
          this.captureVideoTarget.play();
          this.captureVideoTarget.style.display = "inherit";
          this.avatarImgTarget.style.display = "none";
          this.captureImageTarget.style.display = "inherit";
        })
        .catch(err => {
          this.activateWebcamTarget.disabled = true;
          this.activateWebcamTarget.click();
        });
    } else {
      this.activateWebcamTarget.value = this.captureText;
      this.captureVideoTarget.srcObject = null;
      this.captureVideoTarget.style.display = "none";
      this.avatarImgTarget.style.display = "inherit";
      this.captureImageTarget.style.display = "none";
    }
  }

  capturePhoto(ev) {
    const canvas = this.captureCanvasTarget;
    canvas.width = this.captureVideoTarget.videoWidth;
    canvas.height = this.captureVideoTarget.videoHeight;
    const ctx = canvas.getContext("2d");
    ctx.drawImage(this.captureVideoTarget, 0, 0);
    const data = canvas.toDataURL("image/png");
    this.avatarImgTarget.src = data;
    this.webcamActive = true;
    this.activateWebcamTarget.click();
    fetch(data)
      .then(async response => {
        const contentType = response.headers.get('content-type');
        const blob = await response.blob();
        const file = new File([blob], 'capture.png', {
          type: contentType,
          lastModified: new Date(),
        });
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        this.personAvatarTarget.files = dataTransfer.files;
      });
  }
}
