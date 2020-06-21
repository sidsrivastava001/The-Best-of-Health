import { Meteor } from 'meteor/meteor';
import {Promise} from 'meteor/promise'
import {Session} from 'meteor/session'
import { Doctors } from '../imports/doctors.js';
const fs = require('fs');
const util = require('util')

var admin = require("firebase-admin");

const data = require('./hospital.json')
var serviceAccount = require("./hospitallocator-d691c-firebase-adminsdk-c8w0h-ab98a22d39");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://hospitallocator-d691c.firebaseio.com"
});

var db = admin.database();

var ref = db.ref("/hospitals");

Meteor.methods({
  'update_occupancy'(input) {
    if (! this.userId) {
      throw new Meteor.Error('not-authorized');
    }
    var str = "/"+Meteor.user().username+"/occupancy";
    console.log(str)
    var usersRef = ref.child(str);
    //console.log(data);
  //  Tasks.insert(data);
    //console.log(input)
    //console.log(ref)
    //console.log(usersRef);
    usersRef.set(Number(input));

  },
  'update_doctors'(name, insurance, special) {
    if (! this.userId) {
      throw new Meteor.Error('not-authorized');
    }
    var str = "/"+Meteor.user().username+"/doctors";
    console.log(str)
    var usersRef = ref.child(str);
    usersRef.push({doctor: name, insurance: insurance, special: special});
    Doctors.insert({user: Meteor.user().username, doctor: name, insurance: insurance, special: special})
  },
  /*
  'retDoctor'() {
    if (! this.userId) {
      throw new Meteor.Error('not-authorized');
    }
    console.log("Returning")
    return Doctors.find({});
  }
  */
});

Meteor.startup(() => {
  // code to run on server at startup
});
