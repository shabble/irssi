#include "module.h"

static void populate_binding_array(AV *value_array, KEY_REC *key_rec) {
    char *kinfo = key_rec->info->id;
    char *kdata = key_rec->data;

    /* store info, or undef if it's null */
      av_push(value_array, kinfo != NULL
              ? newSVpv(kinfo, strlen(kinfo))
              : newSV(0));

    /* ditto data */
      av_push(value_array, kdata != NULL
              ? newSVpv(kdata, strlen(kdata))
              : newSV(0));
}

MODULE = Irssi::UI::Bindings  PACKAGE = Irssi
PROTOTYPES: ENABLE

HV*
bindings()
PREINIT:
    GSList *info;
    GSList  *key;
CODE:
    RETVAL = newHV();
    sv_2mortal((SV*)RETVAL);

    /* loop stolen from keyboard.c#cmd_show_keys */

    for (info = keyinfos; info != NULL; info = info->next) {
        KEYINFO_REC *rec = info->data;
		for (key = rec->keys; key != NULL; key = key->next) {
			KEY_REC *key_rec = key->data;

            /* return value { key => [ info, data ] } */
            AV* value_array = newAV();

            populate_binding_array(value_array, key_rec);

            /* wedge it all into a reference so we can use it in the hash */
            SV* value_ref = newRV_noinc((SV*)value_array);

            /* and finally, set up the hash */
            hv_store(RETVAL, key_rec->key, strlen(key_rec->key),
                     value_ref, 0);
		}
    }
OUTPUT:
    RETVAL

SV*
binding_add(key, function, data)
char *key
char *function
char *data
CODE:
    if (key_info_find(function) == NULL)
        RETVAL = &PL_sv_no;
	else {
        key_configure_add(function, key, data);
        RETVAL = &PL_sv_yes;
    }
OUTPUT:
   RETVAL

AV*
binding_find(searchkey)
char *searchkey
PREINIT:
    GSList *info, *key;
    int    len;
    int    done = 0;
CODE:
    RETVAL = newAV();
    sv_2mortal((SV*)RETVAL);

    len = searchkey == NULL ? 0 : strlen(searchkey);

    for (info = keyinfos; info != NULL; info = info->next) {
        KEYINFO_REC *rec = info->data;

        for (key = rec->keys; key != NULL; key = key->next) {
            KEY_REC *key_rec = key->data;

            if (strlen(key_rec->key) != len) {
                continue;
            }

            if (g_strncasecmp(key_rec->key, searchkey, len) == 0) {
                populate_binding_array(RETVAL, key_rec);
                done = 1;
                break;
            }
        }
        if (done) { break; }
    }
OUTPUT:
   RETVAL

void
binding_remove(key)
char *key
CODE:
    key_configure_remove(key);
