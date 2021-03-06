import { NativeModules } from 'react-native';
const { RNZendesk } = NativeModules;

export function initialize(config) {
    // appId: string
    // clientId: string
    // zendeskUrl: string
    RNZendesk.initialize(config);
}

export function identifyJWT(token) {
    RNZendesk.identifyJWT(token);
}

export function registerPushNotifications(token) {
    RNZendesk.registerPushNotifications(token);
}

export function unregisterPushNotifications() {
    RNZendesk.unregisterPushNotifications();
}

export function identifyAnonymous(name, email) {
    RNZendesk.identifyAnonymous(name, email);
}

export function showHelpCenter(options) {
    RNZendesk.showHelpCenter(options);
}

export function showNewTicket(options) {
    RNZendesk.showNewTicket(options);
}

export function showTicketList() {
    RNZendesk.showTicketList();
}

export function showTicketListWithCustomAction(callback) {
    RNZendesk.showTicketListWithCustomAction(callback);
}
