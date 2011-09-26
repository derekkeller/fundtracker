// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  if($("p.notice")[0].innerHTML != ''){
	   $('p.notice').show();
  }
  if($('p.alert')[0].innerHTML != ''){
		 $('p.alert').show();
  }
		
});

function to_organization_index(t) {
	if(t != undefined) {
		location.href = '/admin/organizations/' + t.value;
	}
}

function to_fund_show(t, oid) {
	if(t.value != '') {
		location.href = '/admin/organizations/' + oid + '/funds/' + t.value;
	} else {
		location.href = '/admin/organizations/' + oid;
	}
}

function to_company_show(f, oid, fid) {
	if(f.value != '') {
		location.href = '/admin/organizations/' + oid + '/funds/' + fid + '/companies/' + f.value;
	} else {
		location.href = '/admin/organizations/' + oid + '/funds/' + fid;
	}
}
