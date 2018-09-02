import Peer from 'skyway-js';

document.addEventListener('DOMContentLoaded', (event) => {
  const peer = new Peer({
    key: 'f9b3b9aa-98f6-4bb5-8370-da8733e59521',
    debug: 3,
  });
  const dom = {
    otherVideos: document.getElementById('other-videos'),
    endCallButton: document.getElementById('end-call'),
    retryButton: document.getElementById('retry'),
    audioSelect: document.getElementById('audioSource'),
    videoSelect: document.getElementById('videoSource'),
    selfVideo: document.getElementById('self-video'),
    roomName: document.getElementsByTagName('h1')[0],
  };
  let room;

  peer.on('open', () => {
    getStreamJoinRoom();
  });

  peer.on('error', (err) => {
    console.error(err.message);
    removeOtherVideos();
  });

  dom.endCallButton.addEventListener('click', () => {
    room.close();
    removeOtherVideos();
  });

  dom.retryButton.addEventListener('click', () => {
    // visualizeElementById('step1-error');
    getStreamJoinRoom();
  });

  navigator.mediaDevices.enumerateDevices()
    .then((deviceInfos) => {
      const selectors = [dom.audioSelect, dom.videoSelect];
      const optionValues = selectors.map(select => select.value || '');

      selectors.forEach(select => removeChildren(select));

      // セレクタに入力デバイスを追加
      for (let i = 0; i < deviceInfos.length; i += 1) {
        const deviceInfo = deviceInfos[i];
        const option = document.createElement('option');
        option.value = deviceInfo.deviceId;

        if (deviceInfo.kind === 'audioinput') {
          option.innerText = deviceInfo.label || `Microphone ${dom.audioSelect.childElementCount + 1}`;
          dom.audioSelect.appendChild(option);
        } else if (deviceInfo.kind === 'videoinput') {
          option.innerText = deviceInfo.label || `Camera ${dom.videoSelect.childElementCount + 1}`
          dom.videoSelect.appendChild(option);
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

      dom.videoSelect.addEventListener('change', getStreamJoinRoom);
      dom.audioSelect.addEventListener('change', getStreamJoinRoom);
    })
    .catch(err => console.error(err));

  const getStreamJoinRoom = () => {
    const constraints = {audio: true, video: true};

    navigator.mediaDevices.getUserMedia(constraints)
      .then((stream) => {
        dom.selfVideo.srcObject = stream;
        // fixme styles
        setVideoStyles(dom.selfVideo);

        if (room) {
          room.replaceStream(stream);
          return;
        }
        const roomName = dom.roomName.innerText;
        room = peer.joinRoom(roomName, {mode: 'sfu', stream: stream});

        removeOtherVideos();

        setRoomEvents(room);
      })
      .catch((err) => {
        // hideElementById('step1-error');
        console.error(err);
      });
  };

  const setRoomEvents = (room) => {
    room.on('stream', (stream) => {
      const id = videoId(stream.peerId);
      const div = document.createElement('div');
      const video = document.createElement('video');
      div.id = id;
      video.srcObject = stream;
      setVideoStyles(video);

      div.appendChild(video);
      dom.otherVideos.appendChild(div);
    });

    room.on('removeStream', (stream) => {
      removeSelf(document.getElementById(videoId(stream.peerId)));
    });

    room.on('close', removeOtherVideos);

    // room.on('log', (array) => {
    //   console.log(array);
    // });

    room.on('peerJoin', (peerId) => {
      console.log(`${peerId}さんが参加しました`);
    });

    room.on('peerLeave', (peerId) => {
      console.log(`${peerId}さんが退出しました`);
      removeSelf(document.getElementById(videoId(peerId)));
    });

    // hideElementById('step1');
    // hideElementById('removeOtherVideos');
    // visualizeElementById('step3');
  };

  const removeChildren = (element) => {
    while (element.firstChild) {
      element.removeChild(element.firstChild);
    }
  };

  const removeOtherVideos = () => {
    removeChildren(dom.otherVideos);
  };

  const removeSelf = (element) => {
    if(element.parentNode){
      element.parentNode.removeChild(element);
    }
  };

  const videoId = (peerId => `video-${peerId}`);

  // const visualizeElementById = (id) => {
  //   document.getElementById(id).style.display = 'none';
  // };
  //
  // const hideElementById = (id) => {
  //   document.getElementById(id).style.display = 'block';
  // };

  const setVideoStyles = (video) => {
    video.playsinline = true;
    video.autoplay = true;
    video.width = 200;
    video.style.display = 'inline-block';
    video.play();
  };
});
