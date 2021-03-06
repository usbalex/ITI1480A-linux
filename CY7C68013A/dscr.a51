; Copyright (C) 2013-2015  Vincent Pelletier <plr.vincent@gmail.com>
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
.module DEV_DSCR

; descriptor types
; same as setupdat.h
DSCR_DEVICE_TYPE=1
DSCR_CONFIG_TYPE=2
DSCR_STRING_TYPE=3
DSCR_INTERFACE_TYPE=4
DSCR_ENDPOINT_TYPE=5
DSCR_DEVQUAL_TYPE=6

; for the repeating interfaces
DSCR_INTERFACE_LEN=9
DSCR_ENDPOINT_LEN=7

; endpoint types
ENDPOINT_TYPE_CONTROL=0
ENDPOINT_TYPE_ISO=1
ENDPOINT_TYPE_BULK=2
ENDPOINT_TYPE_INT=3

BCD_USB2 = 0x0002

; Measured power consumption:
; Blank              70mA
; FX2 programmed    100mA
; Capture (no Vbus) 180mA
; Capture (110kB/s) 250mA
; Capture stopped   180mA
; Suspended         <10mA (below measurement precision)
; 250 / 2 = 0x7d
MAX_POWER = 0x7d

    .globl	_dev_dscr, _dev_qual_dscr, _highspd_dscr, _fullspd_dscr, _dev_strings, _serial_number_dscr
; These need to be in code memory.  If
; they aren't you'll have to manully copy them somewhere
; in code memory otherwise SUDPTRH:L don't work right
    .area	DSCR_AREA	(CODE)

.even
_dev_dscr:
	.db	dev_dscr_end-_dev_dscr	; bLength
	.db	DSCR_DEVICE_TYPE	; bDescriptorType
	.dw	BCD_USB2		; bcdUSB
	.db	0			; bDeviceClass
	.db	0			; bDeviceSubClass
	.db	0			; bDeviceProtocol
	.db	64			; bMaxPacketSize0
	.dw	0xc016			; idVendor
	.dw	0xa907			; idProduct
	.dw	0			; bcdDevice
	.db	1			; iManufacturer
	.db	2			; iProduct
	.db	3			; iSerialNumber
	.db	1			; bNumConfigurations
dev_dscr_end:

.even
_dev_qual_dscr:
	.db	dev_qualdscr_end-_dev_qual_dscr	; bLength
	.db	DSCR_DEVQUAL_TYPE		; bDescriptorType
	.dw	BCD_USB2			; bcdUSB
	.db	0				; bDeviceClass
	.db	0				; bDeviceSubClass
	.db	0				; bDeviceProtocol
	.db	64				; bMaxPacketSize0
	.db	1				; bNumConfigurations
	.db	0				; bReserved
dev_qualdscr_end:

; Configuration 1
.even
_highspd_dscr:
	.db	highspd_dscr_end-_highspd_dscr	; bLength
	.db	DSCR_CONFIG_TYPE		; bDescriptorType
	; wTotalLength (can't use .dw because byte order is different)
	.db	(highspd_dscr_realend-_highspd_dscr) % 256
	.db	(highspd_dscr_realend-_highspd_dscr) / 256
	.db	1				; bNumInterfaces
	.db	1				; bConfigurationValue
	.db	4				; iConfiguration
	.db	0x80				; bmAttributes
	.db	MAX_POWER			; bMaxPower
highspd_dscr_end:
; all the interfaces next
	.db	DSCR_INTERFACE_LEN	; bLength
	.db	DSCR_INTERFACE_TYPE	; bDescriptorType
	.db	0			; bInterfaceNumber
	.db	0			; bAlternateSetting
	.db	1			; bNumEndpoints
	.db	0xff			; bInterfaceClass
	.db	0			; bInterfaceSubClass
	.db	0			; bInterfaceProtocol
	.db	0			; iInterface
; endpoint 2 in
	.db	DSCR_ENDPOINT_LEN	; bLength
	.db	DSCR_ENDPOINT_TYPE	; bDescriptorType
	.db	0x82			; bEndpointAdress
	.db	ENDPOINT_TYPE_BULK	; bmAttributes
	.dw	0x0002			; wMaxPacketSize
	.db	0x00			; bInterval
highspd_dscr_realend:

.even
_fullspd_dscr:
	.db	fullspd_dscr_end-_fullspd_dscr	; bLength
	.db	DSCR_CONFIG_TYPE		; bDescriptorType
	; wTotalLength (can't use .dw because byte order is different)
	.db	(fullspd_dscr_realend-_fullspd_dscr) % 256
	.db	(fullspd_dscr_realend-_fullspd_dscr) / 256
	.db	1				; bNumInterfaces
	.db	1				; bConfigurationValue
	.db	0				; iConfiguration
	.db	0x80				; bmAttributes
	.db	MAX_POWER			; bMaxPower
fullspd_dscr_end:
; all the interfaces next
	.db	DSCR_INTERFACE_LEN	; bLength
	.db	DSCR_INTERFACE_TYPE	; bDescriptorType
	.db	0			; bInterfaceNumber
	.db	0			; bAlternateSetting
	.db	0			; bNumEndpoints
	.db	0			; bInterfaceClass
	.db	0			; bInterfaceSubClass
	.db	0			; bInterfaceProtocol
	.db	0			; string index
fullspd_dscr_realend:

.even
_dev_strings:
string0:
	.db	string0end-string0	; bLength
	.db	DSCR_STRING_TYPE	; bDescriptorType
	.db	0x09, 0x04		; wLANGID (0x0409 is en-US)
string0end:

string1: ; vendor
	.db	string1end-string1	; bLength
	.db	DSCR_STRING_TYPE	; bDescriptorType
	.db	'I, 0
	.db	'n, 0
	.db	't, 0
	.db	'e, 0
	.db	'r, 0
	.db	'n, 0
	.db	'a, 0
	.db	't, 0
	.db	'i, 0
	.db	'o, 0
	.db	'n, 0
	.db	'a, 0
	.db	'l, 0
	.db	' , 0
	.db	'T, 0
	.db	'e, 0
	.db	's, 0
	.db	't, 0
	.db	' , 0
	.db	'I, 0
	.db	'n, 0
	.db	's, 0
	.db	't, 0
	.db	'r, 0
	.db	'u, 0
	.db	'm, 0
	.db	'e, 0
	.db	'n, 0
	.db	't, 0
	.db	's, 0
string1end:

string2: ; device
	.db	string2end-string2	; bLength
	.db	DSCR_STRING_TYPE	; bDescriptorType
	.db	'U, 0
	.db	'S, 0
	.db	'B, 0
	.db	' , 0
	.db	'A, 0
	.db	'n, 0
	.db	'a, 0
	.db	'l, 0
	.db	'y, 0
	.db	'z, 0
	.db	'e, 0
	.db	'r, 0
	.db	' , 0
	.db	'1, 0
	.db	'4, 0
	.db	'8, 0
	.db	'0, 0
	.db	'A, 0
string2end:

string3: ; serial
	; placeholder, filed by main_init() through xdata aliasing of pdata
	.db	string3end-string3	; bLength
	.db	DSCR_STRING_TYPE	; bDescriptorType
_serial_number_dscr:
	.db	'0, 0
	.db	'0, 0
	.db	'0, 0
	.db	'0, 0
	.db	'0, 0
	.db	'0, 0
	.db	'0, 0
	.db	'0, 0
string3end:

string4: ; Configuration 1
	.db	string4end-string4	; bLength
	.db	DSCR_STRING_TYPE	; bDescriptorType
	.db	'S, 0
	.db	't, 0
	.db	'a, 0
	.db	'n, 0
	.db	'd, 0
	.db	'a, 0
	.db	'r, 0
	.db	'd, 0
	.db	'-, 0
	.db	'C, 0
	.db	'o, 0
	.db	'm, 0
	.db	'p, 0
	.db	'l, 0
	.db	'i, 0
	.db	'a, 0
	.db	'n, 0
	.db	't, 0
string4end:

; Canary descriptor: null length, but more importantly null type.
	.db	0
	.db	0
