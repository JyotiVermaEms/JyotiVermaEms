importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
   const firebaseConfig = {
    apiKey: "AIzaSyBLD6cGYyPsFc32eYDByJ9eLCE53Ntcsnc",
    authDomain: "shipment-f4fd0.firebaseapp.com",
    projectId: "shipment-f4fd0",
    storageBucket: "shipment-f4fd0.appspot.com",
    messagingSenderId: "1050628517372",
    appId: "1:1050628517372:web:1c7d79559e1e23149dd679",
    measurementId: "G-MQBD6EWQM8"
  };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });