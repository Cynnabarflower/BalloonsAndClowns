'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "f61e402bcadf5045f1f8558562e6c94f",
"assets/assets/208.JPG": "c10188eaf81310257acc6e7d916440c6",
"assets/assets/209.JPG": "a01841a0e92c4dfef2f0434d5afb70f2",
"assets/assets/219.JPG": "9ceddf1a5bec8b2d6b6bdd1ec831e520",
"assets/assets/balloons.png": "91aa74fe3d7ce5a7c6d27c87d3b80fde",
"assets/assets/close.png": "72a020da978f750f270d19ef7a1764b5",
"assets/assets/clown.png": "f75d315b10c57008ea7ba7cbab3f429c",
"assets/assets/correct.png": "0b429231db8f2801637ef42a100a1310",
"assets/assets/cup.png": "cf0e066ec9be5f6005749776942a0e06",
"assets/assets/plus.png": "8972d7d310197a164353f6c543e8d629",
"assets/assets/tBalloons/201.jpg": "30085f9b2d27a7d18e18afd9bb3c9491",
"assets/assets/tBalloons/202.jpg": "174334a38c5318996829a87309930cf8",
"assets/assets/tBalloons/203.jpg": "00b064799dd3250dbeadb92ea07e51b3",
"assets/assets/tBalloons/204.jpg": "726dd8c0955dd02884c14b6b1b78c6a4",
"assets/assets/tBalloons/205.jpg": "49c6aa6538ae403f6e6f3de84b9d4cda",
"assets/assets/tBalloons/206.jpg": "28745eaa30e4ee3160a1edb49f9c6137",
"assets/assets/tBalloons/207.jpg": "af6abaab2bcc1aceb3fc48af5a6cc39a",
"assets/assets/tBalloons/208.jpg": "57474de13e567ddc89cf47ba28820f60",
"assets/assets/tBalloons/209.jpg": "d9f4b560eccfa4d9ee2d32b367804bd9",
"assets/assets/tBalloons/210.jpg": "8768233eec1eb7bcdfb34928bf005604",
"assets/assets/tBalloons/211.jpg": "01c0071573c7646d1b568a90ffa5ac6d",
"assets/assets/tBalloons/212.jpg": "4b883d68782200e0e0e4fbd3011c45b7",
"assets/assets/tBalloons/213.jpg": "577b5880960bf7f32772c651df963667",
"assets/assets/tBalloons/214.jpg": "d850d3ff6deec600ea8aeb5ccbdc0acc",
"assets/assets/tBalloons/215.jpg": "dfd75ce7641bb26081fc2f6a8a0dda72",
"assets/assets/tBalloons/216.jpg": "0ad41c2737ede4bb2cba36350205453f",
"assets/assets/tBalloons/219.JPG": "9ceddf1a5bec8b2d6b6bdd1ec831e520",
"assets/assets/tBalloons/220.JPG": "06e16e677b5519bb6d9d4c55e702a7ad",
"assets/assets/tBalloons/answers%2520%25E2%2580%2594%2520%25D0%25BA%25D0%25BE%25D0%25BF%25D0%25B8%25D1%258F.txt": "08e8c1b71e2cec2927b4087a467d8349",
"assets/assets/tBalloons/answers.txt": "77969a3093959365efe21b307d785a0d",
"assets/assets/tBalloons/blue.jpg": "301a4ce33eebf3779c76464d3235e602",
"assets/assets/tBalloons/green.jpg": "05384cdf12ad1c6b8c44f1968a232325",
"assets/assets/TRClown/201.jpg": "191aaeecbf644108c3220ac941c14a72",
"assets/assets/TRClown/202.jpg": "f7aedc588e15e6c077490a1efc012040",
"assets/assets/TRClown/203.jpg": "893e17935b4bddb36ec2f214bbdcf92c",
"assets/assets/TRClown/204.jpg": "23c4d44d7bbd720d68ea57ecb6fa3d33",
"assets/assets/TRClown/205.jpg": "491008eba89575b18bc32f7bebc45d51",
"assets/assets/TRClown/206.jpg": "bf4b0df32e41f1f6c3f3e4ec4f53f4ff",
"assets/assets/TRClown/207.jpg": "5fb204e70cf98963f5108c879442af8e",
"assets/assets/TRClown/208.jpg": "0cf765d2034a94204a1692fdee097212",
"assets/assets/TRClown/209.jpg": "3039796012997722553ed7c21ca46166",
"assets/assets/TRClown/210.jpg": "32c7d8db86fe1696376d3027b8c1a79a",
"assets/assets/TRClown/211.jpg": "398e805e7e497b947ece42f22c1f3809",
"assets/assets/TRClown/212.jpg": "1fdcb5e2bd37cda68690e742512b2b9e",
"assets/assets/TRClown/213.jpg": "471332fd58947f02d9fdd67c1057056f",
"assets/assets/TRClown/214.jpg": "bfb53d54ac0c4686039426769a4e6be3",
"assets/assets/TRClown/215.jpg": "84429094be8489349cdfda19bc82e9ba",
"assets/assets/TRClown/216.jpg": "61814cad5ce97af7b9c13d54fad601b9",
"assets/assets/TRClown/answers.txt": "0a1610297bdb16c6b8bb60bca574de33",
"assets/assets/TRClown/blue.jpg": "fd64e707c6ea0ecdaf436eb17b500594",
"assets/assets/TRClown/green.jpg": "10f34774456595a88d9fe23f0a8d549c",
"assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/LICENSE": "c1984cc05c12a1dedbf6148468240b23",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "12dd7a0c6472ff5a970a36c088e97362",
"/": "12dd7a0c6472ff5a970a36c088e97362",
"main.dart.js": "58a9ab79e7e00eb0fd07941f5bc79a1d",
"manifest.json": "cdfbb64b1a1e17eb7f7854c6eb33a60b"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
