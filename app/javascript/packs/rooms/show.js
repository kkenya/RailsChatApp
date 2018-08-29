import Peer from 'skyway-js';

const peer = new Peer({
  key: 'f9b3b9aa-98f6-4bb5-8370-da8733e59521',
  debug: 3,
});
let localStream;
let room;

window.onload = () => {
  peer.on('open', () => {
    step1();
  });

  peer.on('error', (err) => {
    console.error(err.message);
    removeOtherVideos();
  });

  // fixme remove
  document.getElementById('make-call').addEventListener('submit', (event) => {
    console.log('submit');
    event.preventDefault();
    const roomName = document.getElementById('join-room').value;
    if (!roomName) {
      return;
    }
    room = peer.joinRoom(roomName, {stream: localStream});

    step3(room);
  });

  document.getElementById('end-call').addEventListener('click', () => {
    room.close();
    removeOtherVideos();
  });

  document.getElementById('step1-retry').addEventListener('click', () => {
    // document.getElementById('step1-error').style.display = 'block';
    // visualizeElementById('step1-error');
    step1();
  });

  navigator.mediaDevices.enumerateDevices()
    .then((deviceInfos) => {
      const audioSelect = document.getElementById('audioSource');
      const videoSelect = document.getElementById('videoSource');
      const selectors = [audioSelect, videoSelect];
      const optionValues = selectors.map(select => select.value || '');

      selectors.forEach(selector => removeChildrenById(selector.id));

      // セレクタに入力デバイスを追加
      for (let i = 0; i < deviceInfos.length; i += 1) {
        const deviceInfo = deviceInfos[i];
        const option = document.createElement('option');
        option.value = deviceInfo.deviceId;

        if (deviceInfo.kind === 'audioinput') {
          option.innerText = deviceInfo.label || `Microphone ${audioSelect.childElementCount + 1}`;
          audioSelect.appendChild(option);
        } else if (deviceInfo.kind === 'videoinput') {
          option.innerText = deviceInfo.label || `Camera ${videoSelect.childElementCount + 1}`
          videoSelect.appendChild(option);
        }
      }

      // todo optionのvalueまたはselectのvalueが必要か確認
      selectors.forEach((select, selectorIndex) => {
        // selector.children => HTMLCollection
        const children = Array.prototype.slice.call(select.children).some((option) => {
          return option.value === optionValues[selectorIndex];
        });
        if (children) {
          select.value = optionValues[selectorIndex]
        }
      });

      videoSelect.addEventListener('change', step1);
      audioSelect.addEventListener('change', step1);
    })
    .catch(err => console.error(err));

  const step1 = () => {
    const constraints = {audio: true, video: true};

    navigator.mediaDevices.getUserMedia(constraints)
      .then((stream) => {
        const selfVideo = document.getElementById('self-video');
        selfVideo.srcObject = stream;
        localStream = stream;
        // fixme
        // selfVideo.setAttribute('width', '200');
        // selfVideo.style.display = 'inline-block';

        if (room) {
          room.replaceStream(stream);
          return;
        }

        removeOtherVideos();
      })
      .catch((err) => {
        // hideElementById('step1-error');
        console.error(err);
      });
  };

  const step3 = (room) => {
    room.on('stream', (stream) => {
      const id = videoId(stream.peerId);
      const otherVideos = document.getElementById('other-videos');

      const div = document.createElement('div');
      div.id = id;
      // div.style.display = 'inline-block';

      const video = document.createElement('video');
      // fixme
      // video.className = 'remoteVideos';
      video.autoplay = true;
      video.playsinline = true;
      video.srcObject = stream;
      video.play();
      // todo
      // video.setAttribute('playsinline', true);
      // video.setAttribute('width', '200');
      div.appendChild(video);
      otherVideos.appendChild(div);
      // fixme playをdom追加前後どちらにするか
      // video.play();
    });

    room.on('removeStream', (stream) => {
      // fixme
      // const videoContainer = document.getElementById(elementId);
      // videoContainer.parentNode.removeChild(videoContainer);
      removeSelfById(videoId(stream.peerId))
    });

    room.on('close', removeOtherVideos);

    room.on('peerLeave', (peerId) => {
      removeSelfById(videoId(peerId));
    });

    // hideElementById('step1');
    // hideElementById('removeOtherVideos');
    // visualizeElementById('step3');
  };

  const removeChildrenById = (id) => {
    const element = document.getElementById(id);
    while (element.firstChild) {
      element.removeChild(element.firstChild);
    }
  };

  const removeOtherVideos = () => {
    removeChildrenById('other-videos');
  };

  const removeSelfById = (id) => {
    const element = document.getElementById(id);
    element.parentNode.removeChild(element);
  };

  const videoId = (peerId => `video-${peerId}`);

  // const visualizeElementById = (id) => {
  //   document.getElementById(id).style.display = 'none';
  // };
  //
  // const hideElementById = (id) => {
  //   document.getElementById(id).style.display = 'block';
  // };
};
