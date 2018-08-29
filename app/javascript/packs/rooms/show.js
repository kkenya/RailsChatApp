import Peer from 'skyway-js';

const peer = new Peer({
  key: 'f9b3b9aa-98f6-4bb5-8370-da8733e59521',
  debug: 3,
});
let localStream;
let room;

peer.on('open', () => {
  document.getElementById('self-id').innerText = peer.id;
  // fixme
  step1();
});

peer.on('error', (err) => {
  alert(err.message);
  // fixme
  step2();
});

document.getElementById('make-call').addEventListener('submit', (event) => {
  event.preventDefault();
  const roomName = document.getElementById('join-room').value;
  if (!roomName) {
    return;
  }
  room = peer.joinRoom(roomName, {stream: localStream});

  // fixme
  step3();
});

document.getElementById('end-call').addEventListener('click', () => {
  room.close();
  // fixme
  step2();
});

document.getElementById('step1-retry').addEventListener('click', () => {
  document.getElementById('step1-error').style.display = 'block';
  // fixme
  step1();
});

const audioSelect = document.getElementById('audioSource');
const videoSelect = document.getElementById('videoSource');
const selectors = [audioSelect, videoSelect];

navigator.mediaDevices.emurateDevices()
  .then((deviceInfos) => {
    const optionValues = selectors.map(select => select.value || '');

    // fixme
    // selectors.forEach((selector) => {
    //   // 全ての子要素を取り除く
    //   while (selector.firstChild) {
    //     selector.removeChild(selector.firstChild);
    //   }
    // });
    selectors.forEach(selector => removeChildren(selector));

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

    // fixme
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

      // fixme
      step2();
    })
    .catch((err) => {
      elementInvisible('step1-error');
      console.error(err);
    });

  const step2 = () => {
    removeChildren('other-videos');
    elementVisible('step1');
    elementVisible('step3');
    elementInvisible('step2');
    document.getElementById('join-room').focus();
  };

  const step3 = (room) => {
    const peerId = stream.peerId;
    const videoId = `video-${peerId}`;

    room.on('stream', (stream) => {
      // const peerId = stream.peerId;
      // const elementId = `video-${peerId}`;
      const otherVideos = document.getElementById('other-videos');

      const div = document.createElement('div');
      div.id = videoId;
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
      // const peerId = stream.peerId;
      // const elementId = `video-${peerId}`;
      // const videoContainer = document.getElementById(elementId);
      // videoContainer.parentNode.removeChild(videoContainer);
      removeSelf(videoId)
    });

    room.on('close', step2);
    room.on('peerLeave', (peerId) => {
      // const videoContainer = document.getElementById(elementId);
      // videoContainer.parentNode.removeChild(videoContainer);
      removeSelf(videoId);
    });
    elementInvisible('step1');
    elementInvisible('step2');
    elementVisible('step3');
  };
};

const removeChildren = (element) => {
  while (element.firstChild) {
    element.removeChild(element.firstChild);
  }
};

const removeSelf = (id) => {
  const element = document.getElementById(id);
  element.parentNode.removeChild(element);
}

const elementVisible = (id) => {
  document.getElementById(id).style.display = 'none';
};

const elementInvisible = (id) => {
  document.getElementById(id).style.display = 'block';
};

