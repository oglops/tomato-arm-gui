<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/
Tomato VLAN GUI
Copyright (C) 2011 Augusto Bott
http://code.google.com/p/tomato-sdhc-vlan/
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] 高级设置: 防火墙设置</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<% css(); %>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("block_wan,block_wan_limit,block_wan_limit_icmp,block_wan_limit_tr,nf_loopback,ne_syncookies,DSCP_fix_enable,ipv6_ipsec,multicast_pass,multicast_lan,multicast_lan1,multicast_lan2,multicast_lan3,lan_ifname,lan1_ifname,lan2_ifname,lan3_ifname,udpxy_enable,udpxy_stats,udpxy_clients,udpxy_port,ne_snat"); %>

function verifyFields(focused, quiet)
{
/* ICMP */
E('_f_icmp_limit').disabled = !E('_f_icmp').checked;
E('_f_icmp_limit_icmp').disabled = (!E('_f_icmp').checked || !E('_f_icmp_limit').checked);
E('_f_icmp_limit_traceroute').disabled = (!E('_f_icmp').checked || !E('_f_icmp_limit').checked);
var enable_mcast = E('_f_multicast').checked;
E('_f_multicast_lan').disabled = ((!enable_mcast) || (nvram.lan_ifname.length < 1));
E('_f_multicast_lan1').disabled = ((!enable_mcast) || (nvram.lan1_ifname.length < 1));
E('_f_multicast_lan2').disabled = ((!enable_mcast) || (nvram.lan2_ifname.length < 1));
E('_f_multicast_lan3').disabled = ((!enable_mcast) || (nvram.lan3_ifname.length < 1));
if(nvram.lan_ifname.length < 1)
E('_f_multicast_lan').checked = false;
if(nvram.lan1_ifname.length < 1)
E('_f_multicast_lan1').checked = false;
if(nvram.lan2_ifname.length < 1)
E('_f_multicast_lan2').checked = false;
if(nvram.lan3_ifname.length < 1)
E('_f_multicast_lan3').checked = false;
if ((enable_mcast) && (!E('_f_multicast_lan').checked) && (!E('_f_multicast_lan1').checked) && (!E('_f_multicast_lan2').checked) && (!E('_f_multicast_lan3').checked)) {
		ferror.set('_f_multicast', '至少需要在一个局域网网桥上启用 IGMPproxy', quiet);
return 0;
} else {
ferror.clear('_f_multicast');
}
E('_f_udpxy_stats').disabled = !E('_f_udpxy_enable').checked;
E('_f_udpxy_clients').disabled = !E('_f_udpxy_enable').checked;
E('_f_udpxy_port').disabled = !E('_f_udpxy_enable').checked;
return 1;
}
function save()
{
var fom;
if (!verifyFields(null, 0)) return;
fom = E('_fom');
fom.block_wan.value = E('_f_icmp').checked ? 0 : 1;
fom.block_wan_limit.value = E('_f_icmp_limit').checked? 1 : 0;
fom.block_wan_limit_icmp.value = E('_f_icmp_limit_icmp').value;
fom.block_wan_limit_tr.value = E('_f_icmp_limit_traceroute').value;
fom.ne_syncookies.value = E('_f_syncookies').checked ? 1 : 0;
fom.DSCP_fix_enable.value = E('_f_DSCP_fix_enable').checked ? 1 : 0;
	fom.ipv6_ipsec.value = E('_f_ipv6_ipsec').checked ? 1 : 0;
fom.multicast_pass.value = E('_f_multicast').checked ? 1 : 0;
fom.multicast_lan.value = E('_f_multicast_lan').checked ? 1 : 0;
fom.multicast_lan1.value = E('_f_multicast_lan1').checked ? 1 : 0;
fom.multicast_lan2.value = E('_f_multicast_lan2').checked ? 1 : 0;
fom.multicast_lan3.value = E('_f_multicast_lan3').checked ? 1 : 0;
fom.udpxy_enable.value = E('_f_udpxy_enable').checked ? 1 : 0;
fom.udpxy_stats.value = E('_f_udpxy_stats').checked ? 1 : 0;
fom.udpxy_clients.value = E('_f_udpxy_clients').value;
fom.udpxy_port.value = E('_f_udpxy_port').value;
form.submit(fom, 1);
}
</script>
</head>
<body>
<form id='_fom' method='post' action='tomato.cgi'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
<div class='title'>Tomato</div>
	<div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<input type='hidden' name='_nextpage' value='advanced-firewall.asp'>
<input type='hidden' name='_service' value='firewall-restart'>
<input type='hidden' name='block_wan'>
<input type='hidden' name='block_wan_limit'>
<input type='hidden' name='block_wan_limit_icmp'>
<input type='hidden' name='block_wan_limit_tr'>
<input type='hidden' name='ne_syncookies'>
<input type='hidden' name='DSCP_fix_enable'>
<input type='hidden' name='ipv6_ipsec'>
<input type='hidden' name='multicast_pass'>
<input type='hidden' name='multicast_lan'>
<input type='hidden' name='multicast_lan1'>
<input type='hidden' name='multicast_lan2'>
<input type='hidden' name='multicast_lan3'>
<input type='hidden' name='udpxy_enable'>
<input type='hidden' name='udpxy_stats'>
<input type='hidden' name='udpxy_clients'>
<input type='hidden' name='udpxy_port'>

<div class='section-title'>防火墙设置</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '允许回应 ICMP Ping', name: 'f_icmp', type: 'checkbox', value: nvram.block_wan == '0' },
	{ title: '每秒限制', name: 'f_icmp_limit', type: 'checkbox', value: nvram.block_wan_limit != '0' },
	{ title: 'ICMP', indent: 2, name: 'f_icmp_limit_icmp', type: 'text', maxlen: 3, size: 3, suffix: ' <small> 每秒响应次数</small>', value: fixInt(nvram.block_wan_limit_icmp || 1, 1, 300, 5) },
	{ title: 'Traceroute', indent: 2, name: 'f_icmp_limit_traceroute', type: 'text', maxlen: 3, size: 3, suffix: ' <small> 每秒响应次数</small>', value: fixInt(nvram.block_wan_limit_tr || 5, 1, 300, 5) },
null,
	{ title: '启用 SYN cookies', name: 'f_syncookies', type: 'checkbox', value: nvram.ne_syncookies != '0' },
	{ title: '启用 DSCP Fix', name: 'f_DSCP_fix_enable', type: 'checkbox', value: nvram.DSCP_fix_enable != '0', suffix: ' <small>修复 Comcast 不正确的 DSCP</small>' },
	{ title: 'IPv6 安全通道', name: 'f_ipv6_ipsec', type: 'checkbox', value: nvram.ipv6_ipsec != '0' }
]);
</script>
</div>
<div class='section-title'>NAT</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: 'NAT 回环', name: 'nf_loopback', type: 'select', options: [[0,'所有'],[1,'仅转发'],[2,'关闭']], value: fixInt(nvram.nf_loopback, 0, 2, 1) },
	{ title: 'NAT 目标', name: 'ne_snat', type: 'select', options: [[0,'MASQUERADE'],[1,'SNAT']], value: nvram.ne_snat }
]);
</script>
</div>

<div class='section-title'>组播</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: '启用 IGMPproxy', name: 'f_multicast', type: 'checkbox', value: nvram.multicast_pass == '1' },
{ title: 'LAN', indent: 2, name: 'f_multicast_lan', type: 'checkbox', value: (nvram.multicast_lan == '1') },
{ title: 'LAN1', indent: 2, name: 'f_multicast_lan1', type: 'checkbox', value: (nvram.multicast_lan1 == '1') },
{ title: 'LAN2', indent: 2, name: 'f_multicast_lan2', type: 'checkbox', value: (nvram.multicast_lan2 == '1') },
{ title: 'LAN3', indent: 2, name: 'f_multicast_lan3', type: 'checkbox', value: (nvram.multicast_lan3 == '1') },
null,
	{ title: '启用 Udpxy', name: 'f_udpxy_enable', type: 'checkbox', value: (nvram.udpxy_enable == '1') },
	{ title: '启用客户端统计', indent: 2, name: 'f_udpxy_stats', type: 'checkbox', value: (nvram.udpxy_stats == '1') },
	{ title: '最大客户端数量', indent: 2, name: 'f_udpxy_clients', type: 'text', maxlen: 4, size: 6, value: fixInt(nvram.udpxy_clients || 3, 1, 5000, 3) },
	{ title: 'Udpxy 端口', indent: 2, name: 'f_udpxy_port', type: 'text', maxlen: 5, size: 7, value: fixPort(nvram.udpxy_port, 4022) }

]);
</script>
</div>

<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
<span id='footer-msg'></span>
	<input type='button' value='保存设置' id='save-button' onclick='save()'>
	<input type='button' value='取消设置' id='cancel-button' onclick='reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
