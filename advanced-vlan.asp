<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
Tomato VLAN GUI
Copyright (C) 2011-2012 Augusto Bott
http://code.google.com/p/tomato-sdhc-vlan/
Tomato GUI
Copyright (C) 2006-2007 Jonathan Zarate
http://www.polarcloud.com/tomato/
Tomato VLAN update and bug correction
Copyright (C) 2011-2012 Vicente Soriano
http://tomatoraf.com
Tomato Native VLAN support added
Jan	2014 by Aaron Finney
https://github.com/slash31/TomatoE
VLAN Port Order by 't_model_name'
June 2014 Tvlz
https://bitbucket.org/tvlz/tvlz-advanced-vlan/

	** Last Updated - Aug 10 2016 - Tvlz **

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] 高级设置: VLAN设置</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<% css(); %>
<script type='text/javascript' src='tomato.js'></script>
<style type='text/css'>
#vlan-grid .co1,
#vlan-grid .co2,
#vlan-grid .co3,
#vlan-grid .co4,
#vlan-grid .co5,
#vlan-grid .co6,
#vlan-grid .co7,
#vlan-grid .co8,
#vlan-grid .co9,
#vlan-grid .co10,
#vlan-grid .co11,
#vlan-grid .co12,
#vlan-grid .co13,
#vlan-grid .co14 {
text-align: center;
}
#vlan-grid .co2 {
width: 60px;
}
#vlan-grid .centered {
text-align: center;
}
</style>
<script type='text/javascript' src='wireless.jsx?_http_id=<% nv(http_id); %>'></script>
<script type='text/javascript' src='interfaces.js'></script>
<script type='text/javascript'>
<% nvram ("t_model_name,vlan0ports,vlan1ports,vlan2ports,vlan3ports,vlan4ports,vlan5ports,vlan6ports,vlan7ports,vlan8ports,vlan9ports,vlan10ports,vlan11ports,vlan12ports,vlan13ports,vlan14ports,vlan15ports,vlan0hwname,vlan1hwname,vlan2hwname,vlan3hwname,vlan4hwname,vlan5hwname,vlan6hwname,vlan7hwname,vlan8hwname,vlan9hwname,vlan10hwname,vlan11hwname,vlan12hwname,vlan13hwname,vlan14hwname,vlan15hwname,wan_ifnameX,wan2_ifnameX,wan3_ifnameX,wan4_ifnameX,manual_boot_nv,boardtype,boardflags,lan_ifname,lan_ifnames,lan1_ifname,lan1_ifnames,lan2_ifname,lan2_ifnames,lan3_ifname,lan3_ifnames,vlan0tag,vlan0vid,vlan1vid,vlan2vid,vlan3vid,vlan4vid,vlan5vid,vlan6vid,vlan7vid,vlan8vid,vlan9vid,vlan10vid,vlan11vid,vlan12vid,vlan13vid,vlan14vid,vlan15vid");%>
var port_vlan_supported = 0;
var trunk_vlan_supported = 1; //Enable on all routers
var unknown_router = 0;
// does not seem to be strictly necessary for boardflags as it's supposed to be a bitmap
nvram['boardflags'] = ((nvram['boardflags'].toLowerCase().indexOf('0x') != -1) ? '0x' : '') + String('0000' + ((nvram['boardflags'].toLowerCase()).replace('0x',''))).slice(-4);
// but the contents of router/shared/id.c seem to indicate string formatting/padding might be required for some models as we check if strings match
nvram['boardtype'] = ((nvram['boardtype'].toLowerCase().indexOf('0x') != -1) ? '0x' : '') + String('0000' + ((nvram['boardtype'].toLowerCase()).replace('0x',''))).slice(-4);
// see http://www.dd-wrt.com/wiki/index.php/Hardware#Boardflags and router/shared/id.c
if(nvram['boardflags'] & 0x0100) { // BFL_ENETVLAN = this board has vlan capability
port_vlan_supported = 1;
}
// TESTED ONLY ON WRT54G v2 (boardtype 0x0101),WRT54GL v1.1 (boardtype 0x0467) and WNR3500L (boardtype 0x04cf)
// info on some of these boardtypes/routers obtained from 
// http://wiki.openwrt.org/toh/asus/start
// http://wiki.openwrt.org/toh/linksys/start
// http://wiki.openwrt.org/toh/start
switch(nvram['t_model_name']) { //Added by Tvlz, June 2014
case 'vlan-testid0':
case 'Belkin Share N300 (F7D3302/F7D7302) v1':
case 'Belkin Play N600 (F7D4302/F7D8302) v1':
case 'D-Link Dir-620 C1':
//	case 'FiberHome HG320':
case 'Linksys E800 v1.0':
case 'Linksys E900 v1.0':
case 'Linksys E1200 v1.0':
case 'Linksys E1200 v2.0':
case 'Linksys E1500 v1.0':
case 'Linksys E1550 v1.0':
case 'Linksys E2500 v1.0':
case 'Linksys E2500 v1/v2/v3':
case 'Linksys E3200 v1.0':
case 'Linksys E4200 v1':
//	case 'Netgear WNDR3700v3':
//	case 'Netgear WNDR4000':
	case 'Netgear WNDR4500 V1':
//	case 'Netgear WNDR4500 V2':
//	case 'Netgear R6300 V1':
COL_P0N = '0';
COL_P1N = '1';
COL_P2N = '2';
COL_P3N = '3';
COL_P4N = '4';
break;
case 'vlan-testid1':
case 'Asus RT-N10U':
case 'Asus RT-N66U':
case 'Belkin N F5D8235-4 v3':
//	case 'Buffalo WZR-D1100H':
//	case 'Buffalo WZR-D1800H':
case 'Cisco M10 v1.0':
case 'Cisco M10 v2.0':
case 'D-Link DIR-865L':
case 'Linksys M20':
case 'Linksys E1000 v1':
case 'Linksys E1000 v2.0':
case 'Linksys E1000 v2.1':
case 'Linksys E2000':
case 'Linksys E3000':
//	case 'Linksys WRT310N':
case 'Linksys WRT320N':
case 'Linksys WRT610N v2':
case 'Tenda N6':
//	case 'Tenda N80':
case 'Tenda W1800R':
COL_P0N = '1';
COL_P1N = '2';
COL_P2N = '3';
COL_P3N = '4';
COL_P4N = '0';
break;
case 'vlan-testid2':
case 'Asus RT-N10P':
case 'Asus RT-N12':
case 'Asus RT-N12 B1':
case 'Asus RT-N15U':
case 'Asus RT-N53':
case 'Asus RT-N53 A1':
	case 'Belkin Share Max N300 (F7D3301/F7D7301) v1':
case 'Belkin Play Max / N600 HD (F7D4301/F7D8301) v1':
	case 'Netcore NR235W': //NOT in Shibby Firmware - https://github.com/Jackysi/advancedtomato/pull/142
//	case 'Netgear WNDR3400':
//	case 'Netgear WNDR3400v2':
//	case 'Netgear WNDR3400v3':
COL_P0N = '3';
COL_P1N = '2';
COL_P2N = '1';
COL_P3N = '0';
COL_P4N = '4';
break;
case 'vlan-testid3':
	case 'Asus RT-N16': //invert port order=checked
case 'Asus RT-AC66U':
	case 'Catchtech CW-5358U':
//	case 'ChinaNet RG200E-CA':
case 'Netgear WNR2000 v2':
case 'Netgear WNR3500L/U/v2':
case 'Netgear WNR3500L v2':
	case 'Tenda N60':
COL_P0N = '4';
COL_P1N = '3';
COL_P2N = '2';
COL_P3N = '1';
COL_P4N = '0';
break;
default:
COL_P0N = '1';
COL_P1N = '2';
COL_P2N = '3';
COL_P3N = '4';
COL_P4N = '0';
unknown_router = '1';
break;
/* K2.6 Routers from Tomatoanon needing port order info from router case
case 'CW-5356U': // brand ??
case 'ZTE H218N':
case 'ZTE ZXV10 H618B':
case 'Linksys WRT160N':
case 'Linksys WRT300N v1':
case 'D-Link DIR-627':
case 'Netcore NI360/Q3':
case 'PHICOMM FIR302b':
case 'Vivick Q-W601':
case 'Netcore NW715P':
*/
}
var COL_VID = 0;
var COL_MAP = 1;
var COL_P0  = 2;
var COL_P0T = 3;
var COL_P1  = 4;
var COL_P1T = 5;
var COL_P2  = 6;
var COL_P2T = 7;
var COL_P3  = 8;
var COL_P3T = 9;
var COL_P4  = 10;
var COL_P4T = 11;
var COL_VID_DEF = 12;
var COL_BRI = 13;
var vlt = nvram.vlan0tag | '0';
// set to either 5 or 8 when nvram settings are read (FastE or GigE routers)
var SWITCH_INTERNAL_PORT=0;
function verifyFields(focused, quiet){
for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
var u = wl_fface(uidx);
var wlan = E('_f_bridge_wlan'+u+'_to');
if(nvram.lan_ifname.length < 1)
wlan.options[0].disabled=true;
if(nvram.lan1_ifname.length < 1)
wlan.options[1].disabled=true;
if(nvram.lan2_ifname.length < 1)
wlan.options[2].disabled=true;
if(nvram.lan3_ifname.length < 1)
wlan.options[3].disabled=true;
}
var e = E('_vlan0tag');
if (!v_range('_vlan0tag', quiet, 0, 4080)) return 0;
var v = parseInt(e.value);
e.value = v - (v % 16);
if ((e.value != vlt) && (typeof(vlg) != 'undefined')) {
vlg.populate();
vlt = e.value;
}
return 1;
}
function save() {
if (vlg.isEditing()) return;
var fom = E('_fom');
// wipe out relevant fields just in case this is not the first time we try to submit
for (var i = 0 ; i <= MAX_VLAN_ID ; i++) {
fom['vlan' + i + 'ports'].value = '';
fom['vlan' + i + 'hwname'].value = '';
fom['vlan' + i + 'vid'].value = '';
}
fom['wan_ifnameX'].value = '';
fom['lan_ifnames'].value = '';
fom['lan1_ifnames'].value = '';
fom['lan2_ifnames'].value = '';
fom['lan3_ifnames'].value = '';
fom['wan2_ifnameX'].value = '';
/* MULTIWAN-BEGIN */
fom['wan3_ifnameX'].value = '';
fom['wan4_ifnameX'].value = '';
/* MULTIWAN-END */

var v = '';
var d = vlg.getAllData();
for (var i = 0; i < d.length; ++i) {
var p = '';
p += (d[i][COL_P0].toString() != '0') ? COL_P0N : '';
p += ((trunk_vlan_supported) && (d[i][COL_P0T].toString() != '0')) ? 't' : '';
p += trailingSpace(p);
p += (d[i][COL_P1].toString() != '0') ? COL_P1N : '';
p += ((trunk_vlan_supported) && (d[i][COL_P1T].toString() != '0')) ? 't' : '';
p += trailingSpace(p);
p += (d[i][COL_P2].toString() != '0') ? COL_P2N : '';
p += ((trunk_vlan_supported) && (d[i][COL_P2T].toString() != '0')) ? 't' : '';
p += trailingSpace(p);
p += (d[i][COL_P3].toString() != '0') ? COL_P3N : '';
p += ((trunk_vlan_supported) && (d[i][COL_P3T].toString() != '0')) ? 't' : '';
p += trailingSpace(p);
p += (d[i][COL_P4].toString() != '0') ? COL_P4N : '';
p += ((trunk_vlan_supported) && (d[i][COL_P4T].toString() != '0')) ? 't' : '';
p += trailingSpace(p);
p += (d[i][COL_VID_DEF].toString() != '0') ? (SWITCH_INTERNAL_PORT + '*') : SWITCH_INTERNAL_PORT;
// arrange port numbers in ascending order just to be safe (not sure if this is really needed... mostly, cosmetics?)
p = p.split(" ");
p = p.sort(cmpInt);
p = p.join(" ");
v += (d[i][COL_VID_DEF].toString() != '0') ? d[i][0] : '';
fom['vlan'+d[i][COL_VID]+'ports'].value = p;
fom['vlan'+d[i][COL_VID]+'hwname'].value = 'et0';
fom['vlan'+d[i][COL_VID]+'vid'].value = ((d[i][COL_MAP].toString() != '') && (d[i][COL_MAP].toString() != '0')) ? d[i][COL_MAP] : '';
fom['wan_ifnameX'].value += (d[i][COL_BRI] == '2') ? 'vlan'+d[i][0] : '';
fom['lan_ifnames'].value += (d[i][COL_BRI] == '3') ? 'vlan'+d[i][0] : '';
/* REMOVE-BEGIN
//    fom['lan_ifnames'].value += trailingSpace(fom['lan_ifnames'].value);
//    alert('vlan'+d[i][0]+'ports='+fom['vlan'+d[i][0]+'ports'].value+'\nvlan'+d[i][0]+'hwname='+fom['vlan'+d[i][0]+'hwname'].value);
REMOVE-END */
fom['lan1_ifnames'].value += (d[i][COL_BRI] == '4') ? 'vlan'+d[i][0] : '';
fom['lan2_ifnames'].value += (d[i][COL_BRI] == '5') ? 'vlan'+d[i][0] : '';
fom['lan3_ifnames'].value += (d[i][COL_BRI] == '6') ? 'vlan'+d[i][0] : '';
fom['wan2_ifnameX'].value += (d[i][COL_BRI] == '7') ? 'vlan'+d[i][0] : '';
/* MULTIWAN-BEGIN */
fom['wan3_ifnameX'].value += (d[i][COL_BRI] == '8') ? 'vlan'+d[i][0] : '';
fom['wan4_ifnameX'].value += (d[i][COL_BRI] == '9') ? 'vlan'+d[i][0] : '';
/* MULTIWAN-END */
}
for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
var u = wl_fface(uidx);
var wlan = E('_f_bridge_wlan'+u+'_to');
/* REMOVE-BEGIN
//  var wlan = E('_f_bridge_wlan_to');
//  alert(wlan.selectedIndex);
REMOVE-END */
switch(parseInt(wlan.selectedIndex)) {
case 0:
fom['lan_ifnames'].value += ' ' + wl_ifaces[uidx][0];
break;
case 1:
fom['lan1_ifnames'].value += ' ' + wl_ifaces[uidx][0];
break;
case 2:
fom['lan2_ifnames'].value += ' ' + wl_ifaces[uidx][0];
break;
case 3:
fom['lan3_ifnames'].value += ' ' + wl_ifaces[uidx][0];
break;
}
}
/* REMOVE-BEGIN
//  var lif = nvram['lan_ifnames'].split(' ');
//  for (var j = 0; j < lif.length; j++) {
//    fom['lan_ifnames'].value += (lif[j].indexOf('vlan') != -1) ? '' : lif[j];
//    fom['lan_ifnames'].value += trailingSpace(fom['lan_ifnames'].value);
//  }
//  alert('lan_ifnames=' + fom['lan_ifnames'].value + '\n' +
//        'lan1_ifnames=' + fom['lan1_ifnames'].value + '\n' +
//        'lan2_ifnames=' + fom['lan2_ifnames'].value + '\n' +
//        'lan3_ifnames=' + fom['lan3_ifnames'].value);
REMOVE-END */

  fom['manual_boot_nv'].value = 1 //Prevent vlan reset to default

var e = E('footer-msg');
if(vlg.countWan() != 1) {
    e.innerHTML = '无法继续：至少有一个 VID 必须被分配到广域网.';
e.style.visibility = 'visible';
setTimeout(
function() {
e.innerHTML = '';
e.style.visibility = 'hidden';
}, 5000);
return;
}
if(vlg.countLan(0) != 1) {
    e.innerHTML = '无法继续：有且仅有一个 VID 必须分配给主局域网(br0).';
e.style.visibility = 'visible';
setTimeout(
function() {
e.innerHTML = '';
e.style.visibility = 'hidden';
}, 5000);
return;
}
if (v.length < 1) {
    e.innerHTML = '在不设置默认 VID 的情况下无法继续';
e.style.visibility = 'visible';
setTimeout(
function() {
e.innerHTML = '';
e.style.visibility = 'hidden';
}, 5000);
return;
}

  if (confirm("必须重新启动路由器才能继续. 提交更改到 NVRAM 并立即重新启动?"))
form.submit(fom, 0);
}
function trailingSpace(s)
{
return ((s.length>0)&&(s.charAt(s.length-1) != ' ')) ? ' ' : '';
}
if(port_vlan_supported) { // aka if(supported_hardware) block
var vlg = new TomatoGrid();
vlg.setup = function() {
this.init('vlan-grid', '', (MAX_VLAN_ID + 1), [
{ type: 'select', options: [[0, '0'],[1, '1'],[2, '2'],[3, '3'],[4, '4'],[5, '5'],[6, '6'],[7, '7'],[8, '8'],[9, '9'],[10, '10'],[11, '11'],[12, '12'],[13, '13'],[14, '14'],[15, '15']], prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'text', maxlen: 4, prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'checkbox', prefix: '<div class="centered">', suffix: '</div>' },
{ type: 'select', options: [[1, 'none'],[2, 'WAN'],[3, 'LAN (br0)'],[4, 'LAN1 (br1)'],[5, 'LAN2 (br2)'],[6, 'LAN3 (br3)'],[7, 'WAN2'],
/* MULTIWAN-BEGIN */
[8, 'WAN3'],[9, 'WAN4']
/* MULTIWAN-END */
], prefix: '<div class="centered">', suffix: '</div>' }]);

    this.headerSet(['VLAN', 'VID', '端口 1', '标记', '端口 2', '标记', '端口 3', '标记', '端口 4', '标记', 'WAN 端口', '标记', '默认', '桥接']);

vlg.populate();
vlg.canDelete = false;
vlg.sort(0);
vlg.showNewEditor();
vlg.resetNewEditor();
}
vlg.populate = function() {
vlg.removeAllData();
// find out which vlans are supposed to be bridged to each LAN
var bridged = [];
for (var i = 0 ; i <= MAX_BRIDGE_ID ; i++) {
var j = (i == 0) ? '' : i.toString();
var l = nvram['lan' + j + '_ifnames'].split(' ');
/* REMOVE-BEGIN
//      alert('lan' + j + '_ifnames=' + l);
REMOVE-END */
for (var k = 0 ; k < l.length; k++) {
/* REMOVE-BEGIN
//        alert("bridge br" + i + "=vlan" + parseInt(l[k].replace('vlan','')));
REMOVE-END */
if(l[k].indexOf('vlan') != -1) {
/* REMOVE-BEGIN
//        alert('lan' + j + '_ifname=br' + nvram['lan' + j + '_ifname'].replace('br',''));
REMOVE-END */
if (nvram['lan' + j + '_ifname'] != '')
bridged[parseInt(l[k].replace('vlan',''))] = (3 + parseInt(nvram['lan' + j + '_ifname'].replace('br',''))).toString();
else
bridged[parseInt(l[k].replace('vlan',''))] = '1';
}
// WLAN
for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
if(l[k].indexOf(wl_ifaces[uidx][0]) != -1) {
E('_f_bridge_wlan'+wl_fface(uidx)+'_to').selectedIndex=i;
}
}
}
}
// WAN port
bridged[parseInt(nvram['wan_ifnameX'].replace('vlan',''))] = '2';
bridged[parseInt(nvram['wan2_ifnameX'].replace('vlan',''))] = '7';
/* MULTIWAN-BEGIN */
bridged[parseInt(nvram['wan3_ifnameX'].replace('vlan',''))] = '8';
bridged[parseInt(nvram['wan4_ifnameX'].replace('vlan',''))] = '9';
/* MULTIWAN-END

// go thru all possible VLANs
for (var i = 0 ; i <= MAX_VLAN_ID ; i++) {
var port = [];
var tagged = [];
if ((nvram['vlan' + i + 'hwname'].length > 0) || (nvram['vlan' + i + 'ports'].length > 0)) {
// (re)initialize our bitmap for this particular iteration
for (var j=0; j <= MAX_PORT_ID ; j++) {
port[j] = '0';
tagged[j] = '0';
}
// which ports are members of this VLAN?
var m=nvram['vlan' + i + 'ports'].split(' ');
for (var j = 0; j < (m.length) ; j++) {
port[parseInt(m[j].charAt(0))] = '1';
tagged[parseInt(m[j].charAt(0))] = ((trunk_vlan_supported) && (m[j].indexOf('t') != -1)) ? '1' : '0';
}
if (port_vlan_supported) {
if((nvram['vlan' + i + 'ports']).indexOf('*') != -1)
SWITCH_INTERNAL_PORT=(nvram['vlan' + i + 'ports']).charAt((nvram['vlan' + i + 'ports']).indexOf('*')-1);
vlg.insertData(-1, [ i.toString(),
((nvram['vlan' + i + 'vid'] != '') && (nvram['vlan' + i + 'vid'] > 0)) ? (nvram['vlan' + i + 'vid']).toString() : '0',
port[COL_P0N], tagged[COL_P0N],
port[COL_P1N], tagged[COL_P1N],
port[COL_P2N], tagged[COL_P2N],
port[COL_P3N], tagged[COL_P3N],
port[COL_P4N], tagged[COL_P4N],
(((nvram['vlan' + i + 'ports']).indexOf('*') != -1) ? '1' : '0' ),
(bridged[i] != null) ? bridged[i] : '1' ]);
}
}
}
}
vlg.countElem = function(f, v)
{
var data = this.getAllData();
var total = 0;
for (var i = 0; i < data.length; ++i) {
total += (data[i][f] == v) ? 1 : 0;
}
return total;
}
vlg.countDefaultVID = function()
{
return this.countElem(COL_VID_DEF,1);
}
vlg.countVID = function (v)
{
return this.countElem(COL_VID,v);
}
vlg.countWan = function()
{
return this.countElem(COL_BRI,2);
}
vlg.countWan2 = function()
{
return this.countElem(COL_BRI,7);
}

/* MULTIWAN-BEGIN */
vlg.countWan3 = function()
{
return this.countElem(COL_BRI,8);
}
vlg.countWan4 = function()
{
return this.countElem(COL_BRI,9);
}
/* MULTIWAN-END

vlg.countLan = function(l)
{
return this.countElem(COL_BRI,l+3);
}
vlg.verifyFields = function(row, quiet) {
var valid = 1;
var f = fields.getAll(row);
for(var i=0; i<= MAX_VLAN_ID ; i++) {
f[COL_VID].options[i].disabled = (this.countVID(i) > 0);
}
for (var i=0; i <= MAX_BRIDGE_ID; i++) {
var j = (i==0) ? '' : i.toString();
f[COL_BRI].options[i+2].disabled = (nvram['lan' + j + '_ifname'].length < 1);
}
if (!v_range(f[COL_MAP], quiet, 0, 4094)) valid = 0;
if ((trunk_vlan_supported) && (f[COL_P0].checked == 1)) {
f[COL_P0T].disabled=0;
/* REMOVE-BEGIN
//      if((f[COL_P0T].checked==0) || (this.countElem(COL_P0,1)>0) )
//      if(this.countElem(COL_P0,1)>0) {
//      }
REMOVE-END */
} else {
f[COL_P0T].disabled=1;
f[COL_P0T].checked=0;
}
if ((trunk_vlan_supported) && (f[COL_P1].checked == 1)) {
f[COL_P1T].disabled=0;
} else {
f[COL_P1T].disabled=1;
f[COL_P1T].checked=0;
}
if ((trunk_vlan_supported) && (f[COL_P2].checked == 1)) {
f[COL_P2T].disabled=0;
} else {
f[COL_P2T].disabled=1;
f[COL_P2T].checked=0;
}
if ((trunk_vlan_supported) && (f[COL_P3].checked == 1)) {
f[COL_P3T].disabled=0;
} else {
f[COL_P3T].disabled=1;
f[COL_P3T].checked=0;
}
if ((trunk_vlan_supported) && (f[COL_P4].checked == 1)) {
f[COL_P4T].disabled=0;
} else {
f[COL_P4T].disabled=1;
f[COL_P4T].checked=0;
}
// Modifications to enable Native VLAN support(allow one untagged vlan per port) by default
if ((f[COL_P0].checked == 1) && (this.countElem(COL_P0,1)>0)) {
if (((this.countElem(COL_P0,1)-1) >= this.countElem(COL_P0T,1)) && (f[COL_P0T].checked==0)) {
          ferror.set(f[COL_P0T], '每个端口只允许一个未标记的 VLAN（Native VLAN）', quiet);
valid=0;
} else {
ferror.clear(f[COL_P0T]);
}
}
if ((f[COL_P1].checked == 1) && (this.countElem(COL_P1,1)>0)) {
if (((this.countElem(COL_P1,1)-1) >= this.countElem(COL_P1T,1)) && (f[COL_P1T].checked==0)) {
          ferror.set(f[COL_P1T], '每个端口只允许一个未标记的 VLAN（Native VLAN）', quiet);
valid=0;
} else {
ferror.clear(f[COL_P1T]);
}
}
if ((f[COL_P2].checked == 1) && (this.countElem(COL_P2,1)>0)) {
if (((this.countElem(COL_P2,1)-1) >= this.countElem(COL_P2T,1)) && (f[COL_P2T].checked==0)) {
          ferror.set(f[COL_P2T], '每个端口只允许一个未标记的 VLAN（Native VLAN）', quiet);
valid=0;
} else {
ferror.clear(f[COL_P2T]);
}
}
if ((f[COL_P3].checked == 1) && (this.countElem(COL_P3,1)>0)) {
if (((this.countElem(COL_P3,1)-1) >= this.countElem(COL_P3T,1)) && (f[COL_P3T].checked==0)) {
          ferror.set(f[COL_P3T], '每个端口只允许一个未标记的 VLAN（Native VLAN）', quiet);
valid=0;
} else {
ferror.clear(f[COL_P3T]);
}
}
if ((f[COL_P4].checked == 1) && (this.countElem(COL_P4,1)>0)) {
if (((this.countElem(COL_P4,1)-1) >= this.countElem(COL_P4T,1)) && (f[COL_P4T].checked==0)) {
          ferror.set(f[COL_P4T], '每个端口只允许一个未标记的 VLAN（Native VLAN）', quiet);
valid=0;
} else {
ferror.clear(f[COL_P4T]);
}
}
if(this.countDefaultVID() > 0) {
f[COL_VID_DEF].disabled=1;
f[COL_VID_DEF].checked=0;
}
if((this.countDefaultVID() > 0) && (f[COL_VID_DEF].checked ==1)) {
      ferror.set(f[COL_VID_DEF], '只能选择一个 VID 作为默认 VID', quiet);
valid = 0;
} else {
ferror.clear(f[COL_VID_DEF]);
}
if(this.countVID(f[COL_VID].selectedIndex) > 0) {
      ferror.set(f[COL_VID], '无法给 VID 添加多个条目 ' + f[0].selectedIndex, quiet);
valid = 0;
} else {
ferror.clear(f[COL_VID]);
}
if ((this.countWan() > 0) && (f[COL_BRI].selectedIndex == 1)) {
      ferror.set(f[COL_BRI],'只有一个 VID 可以用作于 WAN', quiet);
valid = 0;
} else {
ferror.clear(f[COL_BRI]);
}
if ((this.countWan2() > 0) && (f[COL_BRI].selectedIndex == 6)) {
ferror.set(f[COL_BRI],'只有一个 VID 可以用作于 WAN2', quiet);
valid = 0;
} else {
ferror.clear(f[COL_BRI]);
}

/* MULTIWAN-BEGIN */
if ((this.countWan3() > 0) && (f[COL_BRI].selectedIndex == 7)) {
ferror.set(f[COL_BRI],'只有一个 VID 可以用作于 WAN3', quiet);
valid = 0;
} else {
ferror.clear(f[COL_BRI]);
}
if ((this.countWan4() > 0) && (f[COL_BRI].selectedIndex == 8)) {
ferror.set(f[COL_BRI],'只有一个 VID 可以用作于 WAN4', quiet);
valid = 0;
} else {
ferror.clear(f[COL_BRI]);
}
/* MULTIWAN-END

for(var i=0; i<4; i++) {
if ((this.countLan(i) > 0) && (f[COL_BRI].selectedIndex == (i+2))) {
        ferror.set(f[COL_BRI],'在任何时候有且仅有一个 VID 可以用于 LAN' + ((i==0) ? '' : i ) + ' (br'+i+') at any time', quiet);
valid = 0;
} else {
ferror.clear(f[COL_BRI]);
}
}
return valid;
}
vlg.dataToView = function(data) {
return [data[COL_VID],
((data[COL_MAP].toString() == '') || (data[COL_MAP].toString() == '0')) ? (parseInt(E('_vlan0tag').value) * 1 + data[COL_VID] *1 ).toString() : data[COL_MAP].toString(),
(data[COL_P0].toString() != '0') ? 'Yes' : '',
    (data[COL_P0T].toString() != '0') ? 'On' : '',
(data[COL_P1].toString() != '0') ? 'Yes' : '',
    (data[COL_P1T].toString() != '0') ? 'On' : '',
(data[COL_P2].toString() != '0') ? 'Yes' : '',
    (data[COL_P2T].toString() != '0') ? 'On' : '',
(data[COL_P3].toString() != '0') ? 'Yes' : '',
    (data[COL_P3T].toString() != '0') ? 'On' : '',
(data[COL_P4].toString() != '0') ? 'Yes' : '',
    (data[COL_P4T].toString() != '0') ? 'On' : '',
(data[COL_VID_DEF].toString() != '0') ? '*' : '',
['', 'WAN', 'LAN (br0)', 'LAN1 (br1)', 'LAN2 (br2)', 'LAN3 (br3)', 'WAN2'
/* MULTIWAN-BEGIN */
, 'WAN3', 'WAN4'
/* MULTIWAN-END
][data[COL_BRI] - 1]];
}
vlg.dataToFieldValues = function (data) {
return [data[COL_VID],
data[COL_MAP],
(data[COL_P0] != 0) ? 'checked' : '',
(data[COL_P0T] != 0) ? 'checked' : '',
(data[COL_P1] != 0) ? 'checked' : '',
(data[COL_P1T] != 0) ? 'checked' : '',
(data[COL_P2] != 0) ? 'checked' : '',
(data[COL_P2T] != 0) ? 'checked' : '',
(data[COL_P3] != 0) ? 'checked' : '',
(data[COL_P3T] != 0) ? 'checked' : '',
(data[COL_P4] != 0) ? 'checked' : '',
(data[COL_P4T] != 0) ? 'checked' : '',
(data[COL_VID_DEF] != 0) ? 'checked' : '',
data[COL_BRI]];
}
vlg.fieldValuesToData = function(row) {
var f = fields.getAll(row);
return [f[COL_VID].value,
f[COL_MAP].value,
f[COL_P0].checked ? 1 : 0,
f[COL_P0T].checked ? 1 : 0,
f[COL_P1].checked ? 1 : 0,
f[COL_P1T].checked ? 1 : 0,
f[COL_P2].checked ? 1 : 0,
f[COL_P2T].checked ? 1 : 0,
f[COL_P3].checked ? 1 : 0,
f[COL_P3T].checked ? 1 : 0,
f[COL_P4].checked ? 1 : 0,
f[COL_P4T].checked ? 1 : 0,
f[COL_VID_DEF].checked ? 1 : 0,
f[COL_BRI].value];
}
vlg.onCancel = function() {
this.removeEditor();
this.showSource();
this.disableNewEditor(false);
this.resetNewEditor();
}
vlg.onAdd = function() {
var data;
this.moving = null;
this.rpHide();
if (!this.verifyFields(this.newEditor, false)) return;
data = this.fieldValuesToData(this.newEditor);
this.insertData(-1, data);
this.disableNewEditor(false);
this.resetNewEditor();
this.resort();
}
vlg.onOK = function() {
var i, data, view;
if (!this.verifyFields(this.editor, false)) return;
data = this.fieldValuesToData(this.editor);
view = this.dataToView(data);
this.source.setRowData(data);
for (i = 0; i < this.source.cells.length; ++i) {
this.source.cells[i].innerHTML = view[i];
}
this.removeEditor();
this.showSource();
this.disableNewEditor(false);
this.resetNewEditor();
this.resort();
}
vlg.onDelete = function() {
this.removeEditor();
elem.remove(this.source);
this.source = null;
this.disableNewEditor(false);
this.resetNewEditor();
}
vlg.sortCompare = function(a, b) {
var obj = TGO(a);
var col = obj.sortColumn;
if (this.sortColumn == 0) {
var r = cmpInt(parseInt(a.cells[col].innerHTML), parseInt(b.cells[col].innerHTML));
} else {
var r = cmpText(a.cells[col].innerHTML, b.cells[col].innerHTML);
}
return obj.sortAscending ? r : -r;
};
vlg.resetNewEditor = function() {
var f = fields.getAll(this.newEditor);
for (var i=0; i <= MAX_BRIDGE_ID; i++) {
var j = (i==0) ? '' : i.toString();
f[COL_BRI].options[i+2].disabled = (nvram['lan' + j + '_ifname'].length < 1);
}
f[COL_MAP].value = '0';
f[COL_VID].selectedIndex=0;
var t = MAX_VLAN_ID;
while((this.countVID(f[COL_VID].selectedIndex) > 0) && (t > 0)) {
f[COL_VID].selectedIndex = (f[COL_VID].selectedIndex%(MAX_VLAN_ID))+1;
t--;
}
for(var i=0; i<= MAX_VLAN_ID ; i++) {
f[COL_VID].options[i].disabled = (this.countVID(i) > 0);
}
f[COL_P0].checked = 0;
f[COL_P0T].checked = 0;
f[COL_P0T].disabled = 1;
f[COL_P1].checked = 0;
f[COL_P1T].checked = 0;
f[COL_P1T].disabled = 1;
f[COL_P2].checked = 0;
f[COL_P2T].checked = 0;
f[COL_P2T].disabled = 1;
f[COL_P3].checked = 0;
f[COL_P3T].checked = 0;
f[COL_P3T].disabled = 1;
f[COL_P4].checked = 0;
f[COL_P4T].checked = 0;
f[COL_P4T].disabled = 1;
f[COL_VID_DEF].checked = 0;
if (this.countDefaultVID()>0)
f[COL_VID_DEF].disabled = 1;
f[COL_BRI].selectedIndex = 0;
ferror.clearAll(fields.getAll(this.newEditor));
}
} // end of the so-called if(supported_device) block
function init() {
if(port_vlan_supported) {
vlg.recolor();
vlg.resetNewEditor();
var c;
if (((c = cookie.get('advanced_vlan_notes_vis')) != null) && (c == '1')) toggleVisibility("notes");
}
}
function toggleVisibility(whichone) {
if (E('sesdiv_' + whichone).style.display == '') {
E('sesdiv_' + whichone).style.display = 'none';
		E('sesdiv_' + whichone + '_showhide').innerHTML = '(点击此处显示)';
cookie.set('advanced_vlan_' + whichone + '_vis', 0);
} else {
E('sesdiv_' + whichone).style.display='';
		E('sesdiv_' + whichone + '_showhide').innerHTML = '(点击此处隐藏)';
cookie.set('advanced_vlan_' + whichone + '_vis', 1);
}
}
function earlyInit() {
if(!port_vlan_supported) {
E('save-button').disabled = 1;
return;
}
if (unknown_router == '1')
E('unknown_router').style.display = '';
}
</script>
</head>
<body onload='init()'>
<form id='_fom' method='post' action='tomato.cgi'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
<div class='title'>Tomato</div>
  <div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>
<input type='hidden' name='_nextpage' value='advanced-vlan.asp'>
<input type='hidden' name='_nextwait' value='30'>
<input type='hidden' name='_reboot' value='1'>
<input type='hidden' name='_nvset' value='1'>
<input type='hidden' name='_commit' value='1'>
<input type='hidden' name='vlan0ports'>
<input type='hidden' name='vlan1ports'>
<input type='hidden' name='vlan2ports'>
<input type='hidden' name='vlan3ports'>
<input type='hidden' name='vlan4ports'>
<input type='hidden' name='vlan5ports'>
<input type='hidden' name='vlan6ports'>
<input type='hidden' name='vlan7ports'>
<input type='hidden' name='vlan8ports'>
<input type='hidden' name='vlan9ports'>
<input type='hidden' name='vlan10ports'>
<input type='hidden' name='vlan11ports'>
<input type='hidden' name='vlan12ports'>
<input type='hidden' name='vlan13ports'>
<input type='hidden' name='vlan14ports'>
<input type='hidden' name='vlan15ports'>
<input type='hidden' name='vlan0hwname'>
<input type='hidden' name='vlan1hwname'>
<input type='hidden' name='vlan2hwname'>
<input type='hidden' name='vlan3hwname'>
<input type='hidden' name='vlan4hwname'>
<input type='hidden' name='vlan5hwname'>
<input type='hidden' name='vlan6hwname'>
<input type='hidden' name='vlan7hwname'>
<input type='hidden' name='vlan8hwname'>
<input type='hidden' name='vlan9hwname'>
<input type='hidden' name='vlan10hwname'>
<input type='hidden' name='vlan11hwname'>
<input type='hidden' name='vlan12hwname'>
<input type='hidden' name='vlan13hwname'>
<input type='hidden' name='vlan14hwname'>
<input type='hidden' name='vlan15hwname'>
<input type='hidden' name='wan_ifnameX'>
<input type='hidden' name='wan2_ifnameX'>
/* MULTIWAN-BEGIN */
<input type='hidden' name='wan3_ifnameX'>
<input type='hidden' name='wan4_ifnameX'>
/* MULTIWAN-END
<input type='hidden' name='manual_boot_nv'>
<input type='hidden' name='lan_ifnames'>
<input type='hidden' name='lan1_ifnames'>
<input type='hidden' name='lan2_ifnames'>
<input type='hidden' name='lan3_ifnames'>
<input type='hidden' name='vlan0vid'>
<input type='hidden' name='vlan1vid'>
<input type='hidden' name='vlan2vid'>
<input type='hidden' name='vlan3vid'>
<input type='hidden' name='vlan4vid'>
<input type='hidden' name='vlan5vid'>
<input type='hidden' name='vlan6vid'>
<input type='hidden' name='vlan7vid'>
<input type='hidden' name='vlan8vid'>
<input type='hidden' name='vlan9vid'>
<input type='hidden' name='vlan10vid'>
<input type='hidden' name='vlan11vid'>
<input type='hidden' name='vlan12vid'>
<input type='hidden' name='vlan13vid'>
<input type='hidden' name='vlan14vid'>
<input type='hidden' name='vlan15vid'>
<div style='display:none' id='unknown_router'>
<div class='section-title'><center>!! 未知端口映射! 使用默认设置!!</center></div>
<div class='fields'><center><a href='http://www.linksysinfo.org/index.php?threads/can-vlan-gui-port-order-be-corrected.70160/#post-247634/'> <b>请按照这些说明进行更正.</b></a>
<br><br> 可参考路由器品牌/型号 (<% nv('t_model_name'); %>),
<br> 和命令 "nvram show | grep vlan1ports" &amp; 的返回结果
<br> 从路由器机身正面看去(端口号从左往右排列).
<br> </center></div>
<br>
</div>
<div id='sesdiv' style='display:none'>
<div class='section-title'>VLAN 设置</div>
<div class='section'>
<table class='tomato-grid' cellspacing=1 id='vlan-grid'></table>
</div>

<!-- / / / -->
<!-- Unneeded - Hide display for Now, remove later?? -->
<div id='vid_offset' style='display:none'>
<div class='section-title'>VID 偏移</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: 'First 802.1Q VLAN tag', name: 'vlan0tag', type: 'text', maxlen:4, size:6,
value: fixInt(nvram.vlan0tag, 0, 4080, 0),
		suffix: ' <small><i>(范围: 0 - 4080; 必须是16的倍数; 0为禁用)</i></small>' }
]);
</script>
</div>
</div>

<!-- / / / -->

<div class='section-title'>无线桥接</div>
<div class='section'>
<script type='text/javascript'>
var f = [];
for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
var u = wl_fface(uidx);
f.push(
    { title: ('桥接 ' + wl_ifaces[uidx][0] + ' 到'), name: ('f_bridge_wlan'+u+'_to'), type: 'select', 
     options: [[0,'LAN (br0)'],[1,'LAN1  (br1)'],[2,'LAN2 (br2)'],[3,'LAN3 (br3)'],[4,'无']], value: 4 } );
}
createFieldTable('',f);
if(port_vlan_supported) vlg.setup();
</script>
</div>
<div class='section-title'>说明 <small><i><a href='javascript:toggleVisibility("notes");'><span id='sesdiv_notes_showhide'>(Click here to hide)</span></a></i></small></div>
<div class='section' id='sesdiv_notes' style='display:none'>
<ul>
<li>如果您注意到 Lan 端口的映射顺序不正确, <a href='http://www.linksysinfo.org/index.php?threads/can-vlan-gui-port-order-be-corrected.70160/#post-247634/'> <b>请按照此链接的说明，将它更正.</b></a></li>
<br>
<li><b>VLAN</b> - VLAN的唯一标识符.</li>
<li><b>VID</b> - 允许 “非常规的” VLAN / VID映射，为每个 VLAN 设置任意 VID (设置为“0”以使用“常规” VLAN / VID映射).</li>
<li><b>端口 1-4 &amp; WAN</b> - 路由器上的哪些以太网端口应该是此 VLAN 的成员.</li>
<li><b>标记</b> - 在特定 端口/ VLAN 上启用 802.1Q 标记以太网帧</li>
<li><b>默认</b> - VLAN ID 分配给路由器接收的未标记帧.</li>
<li><b>桥接</b> - 确定此 VLAN ID 是否应被视为 WAN, 或单独刚刚断开待处理 (如：802.1Q 中继的部件，被手动通过脚本管理等...).</li>
</ul>
<ul>
<li><b>Wireless</b> - Assignments of wireless interfaces to different LAN briges. You should probably be using and/or check things on <a href=advanced-wlanvifs.asp>Advanced/Virtual Wireless</a> and <a href=basic-network.asp>Basic/Network</a>.</li>
</ul>

<small>
<ul>
<li><b>Other relevant notes/hints:</b>
<ul>
<li>One VID <i>must</i> be assigned to WAN.</li>
<li>One VID <i>must</i> be selected as the default.</li>
<script type='text/javascript'>
if(trunk_vlan_supported) {
W('<li>To prevent 802.1Q compatibility issues, avoid using VID "0" as 802.1Q specifies that frames with a tag of "0" do not belong to any VLAN (the tag contains only user priority information).</li>');
W('<li>It may be also recommended to avoid using VID "1" as some vendors consider it special/reserved (for management purposes).</li>');
}
</script>
</ul>
<br>
</ul>
</small>
</div>
</div>
<script type='text/javascript'>
if(!port_vlan_supported) 
W('<i>This feature is not supported on this router.</i>');
else {
E('sesdiv').style.display = '';
}
</script>
</td></tr>
<tr><td id='footer' colspan=2>
<span id='footer-msg'></span>
 <input type='button' value='保存设置' id='save-button' onclick='save()'>
 <input type='button' value='取消设置' id='cancel-button' onclick='javascript:reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>earlyInit(); verifyFields(null,1);</script>
</body>
</html>
