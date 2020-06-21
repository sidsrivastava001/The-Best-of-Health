import { Accounts } from 'meteor/accounts-base';

import './main.html';


import { Doctors } from '../imports/doctors.js';

import { Template } from 'meteor/templating';
import { Session } from 'meteor/session'
import {Mongo} from 'meteor/mongo'
import { Meteor } from 'meteor/meteor';

Session.set("button", "forms");

Accounts.ui.config({
  passwordSignupFields: 'USERNAME_AND_EMAIL',
});


Template.body.helpers({
  setDoctors() {
    console.log("Returning...");
    console.log(Meteor.user().username);
    console.log("Data: " + Doctors.find({user: Meteor.user().username}))
    return Doctors.find({user: Meteor.user().username});
  },
  retNav() {
    if(Session.get("button") == "doctors") {
      return true;
    }
    return false;
  }
});

Template.body.events({
    'submit .occupancy'(event) {
      // Prevent default browser form submit
      event.preventDefault();

      // Get value from form element
      const target = event.target;
      const available = target.capacity.value;

      // Insert a task into the collection
      console.log(available)
      Meteor.call('update_occupancy', available);
      // Clear form
      target.capacity.value = '';
    },
    'submit .doctor'(event) {
      // Prevent default browser form submit
      event.preventDefault();

      // Get value from form element
      const target = event.target;
      const available = target.doctor.value;
      const special = target.special.value;
      var insArr = target.insurance.value.split(',');
      // Insert a task into the collection
      console.log(available);
      console.log(insArr);
      Meteor.call('update_doctors', available, insArr, special);
      // Clear form
      target.doctor.value = '';
      target.insurance.value = '';
    },
    'click .topnav' (input) {
      Session.set("button", input.target.getAttribute('name'));
    }
  });
