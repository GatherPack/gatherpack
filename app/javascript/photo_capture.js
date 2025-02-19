document.addEventListener("turbo:load", ev => {
    let imgElem = document.getElementById("avatar-img");
    if (imgElem) {
        document.getElementById('person_avatar').addEventListener("change", ev => {
            let reader = new FileReader();
            
            reader.addEventListener("load", ev => {
                imgElem.src = ev.target.result;
            });

            reader.readAsDataURL(ev.target.files[0]);

            webcam_active = true;
            activate_webcam.click();
        });
        
        let video = document.getElementById("capture-video");
        video.style.display = "none";

        let activate_webcam = document.getElementById("activate-webcam");
        let capture_text = "Capture from camera";
        let stop_text = "Cancel capture";

        let capture_image = document.getElementById("capture-image");
        let canvas = document.getElementById("capture-canvas");
        let file_input = document.getElementById("person_avatar");

        activate_webcam.value = capture_text;

        let webcam_active = false;
        activate_webcam.addEventListener("click", ev => {
            webcam_active = !webcam_active;
            if (webcam_active) {
                activate_webcam.value = stop_text;
                navigator.mediaDevices
                    .getUserMedia({ video: true, audio: false })
                    .then(stream => {
                        video.srcObject = stream;
                        video.play();
                        video.style.display = "inherit";
                        imgElem.style.display = "none";
                        capture_image.style.display = "inherit";
                    })
                    .catch(err => {
                        activate_webcam.disabled = true;
                        activate_webcam.click();
                    });

            } else {
                activate_webcam.value = capture_text;

                video.srcObject = null;
                video.style.display = "none";
                imgElem.style.display = "inherit";
                capture_image.style.display = "none";
            }
        });

        capture_image.addEventListener("click", ev => {
            let canvas = document.getElementById("capture-canvas");
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const ctx = canvas.getContext("2d");
            ctx.drawImage(video, 0, 0);

            const data = canvas.toDataURL("image/png");
            imgElem.src = data;

            webcam_active = true;
            activate_webcam.click();

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
                    file_input.files = dataTransfer.files;
                })
        });
    }
});
