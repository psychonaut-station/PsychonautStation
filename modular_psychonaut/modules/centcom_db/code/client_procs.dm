
/client/proc/check_centcom_db(new_account)
	if(new_account && CONFIG_GET(string/centcom_ban_db))
		var/datum/http_request/request = new()
		request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/centcom_ban_db)]/[ckey]", "", "")
		request.begin_async()
		UNTIL(request.is_complete())

		var/datum/http_response/response = request.into_response()
		if(response.errored || response.status_code != 200)
			message_admins("Yeni oyuncu [key_name_admin(src)] için sabıka kontrolü sırasında CentCom Ban veritabanı hata verdi. ([response.status_code])")
			send2adminchat("BAN ALERT", "Yeni oyuncu [key_name(src)] için sabıka kontrolü sırasında CentCom Ban veritabanı hata verdi. ([response.status_code])")
		else
			var/list/bans = json_decode(response.body)
			if (bans.len > 0)
				message_admins("<font color='[COLOR_RED]'><B>Yeni oyuncu [key_name_admin(src)] için [bans.len] tane ban kaydı bulundu.</B></font>")
				send2adminchat("BAN ALERT", "Yeni oyuncu [key_name(src)] için [bans.len] tane ban kaydı bulundu.")
