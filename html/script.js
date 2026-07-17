var player;
var isPlayerReady = false;
var currentVolume = 50; 

function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
        height: '100%',
        width: '100%',
        videoId: '', 
        playerVars: {
            'autoplay': 1,
            'controls': 0, 
            'disablekb': 1, 
            'fs': 0,
            'rel': 0, 
            'modestbranding': 1, 
            'cc_load_policy': 0, 
            'iv_load_policy': 3,
            'playsinline': 1 // Empêche certains comportements natifs de plein écran
        },
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });
}

function onPlayerReady(event) {
    isPlayerReady = true;
}

function onPlayerStateChange(event) {
    // YT.PlayerState.PLAYING = La vidéo tourne
    if (event.data === YT.PlayerState.PLAYING) {
        
        setTimeout(() => {
            player.unMute();
            player.setVolume(currentVolume);

            if (typeof player.unloadModule === "function") {
                player.unloadModule("captions");
                player.unloadModule("cc");
            }
            
            // La vidéo a démarré et le son est réglé : ON LÈVE LE RIDEAU NOIR !
            document.getElementById('loading-cover').style.opacity = '0';
            
        }, 100);
    }

    // YT.PlayerState.ENDED = Fin de la vidéo
    if (event.data === YT.PlayerState.ENDED) {
        document.getElementById('video-container').style.display = 'none';
        
        // On remet le rideau opaque pour la prochaine fois
        document.getElementById('loading-cover').style.opacity = '1';
        
        fetch(`https://${GetParentResourceName()}/videoEnded`, {
            method: 'POST',
            body: JSON.stringify({})
        });
    }
}

window.addEventListener('message', function(event) {
    if (!isPlayerReady) return;

    if (event.data.type === "play") {
        currentVolume = event.data.volume !== undefined ? Number(event.data.volume) : 50;
        
        // On affiche le conteneur, mais le rideau noir cache encore la vidéo
        document.getElementById('loading-cover').style.opacity = '1';
        document.getElementById('video-container').style.display = 'block';
        
        player.loadVideoById({
            videoId: event.data.videoId,
            suggestedQuality: 'hd1080'
        });
        
    } 
    else if (event.data.type === "stop") {
        player.stopVideo();
        document.getElementById('video-container').style.display = 'none';
        document.getElementById('loading-cover').style.opacity = '1';
    }
});