import { NativeModules } from 'react-native';
const { RNZendesk } = NativeModules;
// MARK: - Initialization
export function initialize(config) {
    // appId: string
    // clientId: string
    // zendeskUrl: string
    RNZendesk.initialize(config);
}
// MARK: - Indentification
export function identifyJWT(token) {
    RNZendesk.identifyJWT(token);
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
