# SoalShiftSISOP20_modul1_F06
## Contents
- [Soal 1](#Soal-1)
	- [a](#a-tentukan-wilayah-bagian-region-mana-yang-memiliki-keuntungan-profit-paling-sedikit)
	- [b](#b-tampilkan-2-negara-bagian-state-yang-memiliki-keuntungan-profit-paling-sedikit-berdasarkan-hasil-poin-a)
	- [c](#c-tampilkan-10-produk-product-name-yang-memiliki-keuntungan-profit-paling-sedikit-berdasarkan-2-negara-bagian-state-hasil-poin-b)
		
## Soal 1
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum
untuk membuat laporan berdasarkan data yang ada pada file “Sample-Superstore.tsv”.
Namun dia tidak dapat menyelesaikan tugas tersebut

### a. Tentukan wilayah bagian (region) mana yang memiliki keuntungan (profit) paling sedikit

#### Penyelesaian
Menggunakan awk. Berikut merupakan kode awk-nya.
~~~
awk 'BEGIN {FS="\t"; PROCINFO["sorted_in"]="@val_num_asc"}
FNR>1 {reg[$13]+=$21}
END {for(i in reg) print i, reg[i]}' Sample-Superstore.tsv |
awk '{print $1}' | head -1
~~~
Penjelasan:
- Dalam block **BEGIN** 
	- `FS=\"t"` artinya data yang diinput menggunakan "tab" sebagai pembatas kolom.
	- `PROCINFO["sorted_in"]="@val_num_asc"` merupakan fitur yang digunakan untuk meng-scan array menurut value-nya yang berupa numeric secara ascending (kecil ke besar)
- Dalam block **body**
	- `FNR>1` artinya mengabaikan row pertama (yang dalam data ini merupakan title atau atribut)
	- `{reg[$13]+=$21}` mengisi array reg dengan jumlah "profit" (kolom 21) di mana index array reg adalah data pada kolom 13
- Dalam block **END**
	- `{for(i in reg) print i, reg[i]}` iterasi array reg dengan i sebagai indexnya, lalu mencetak semua index dan isi dari array
- `Sample-Superstore.tsv` nama file yang menjadi input
- `awk '{print $1}'` mencetak kolom pertama dari hasil awk yang sebelumnya
- `head -1` membatasi hanya row pertama saja yang ditampilkan

### b. Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling sedikit berdasarkan hasil poin a

#### Penyelesaian
Menggunakan awk, dan memanfaatkan hasil dari a. Berikut merupakan kode awk-nya.
~~~
awk -v min_region="$min_region" 'BEGIN {FS="\t"; PROCINFO["sorted_in"]="@val_num_asc"}
($13~min_region) {state[$11]+=$21}
END{for(i in state) print i, state[i]}' Sample-Superstore.tsv |
awk '{print $1}' | head -2
~~~
Penjelasan:
- `-v min_region="$min_region"` -v merupakan command untuk mendeklarasikan variable min_region di mana valuenya adalah hasil dari perintah sebelumnya
- Dalam block **BEGIN** sama seperti sebelumnya
- Dalam block **body**
	- `($13~min_region)` mencari pattern pada kolom 13 yang memiliki data sama dengan min_region 
	- `{state[$11]+=$21}` mengisi array state dengan jumlah "profit" (kolom 21) di mana index array state adalah data pada kolom 11
- Dalam block **END**
	- `for(i in state) print i, state[i]` iterasi array state dengan i sebagai indexnya, lalu mencetak semua index dan isi dari array
- `head -2` hanya menampilkan dua row teratas

### c. Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling sedikit berdasarkan 2 negara bagian (state) hasil poin b

#### Penyelesaian
Menggunakan awk, dan memanfaatkan hasil dari b. Berikut merupakan kode awk-nya.
~~~
state1="Texas"
state2="Illinois"
awk -v state1="$state1" -v state2="$state2" 'BEGIN {FS="\t"; OFS="\t";
 PROCINFO["sorted_in"]="@val_num_asc"}
($11~state1 || $11~state2) {produk[$17]+=$21}
END{for(i in produk)print i,produk[i]}' Sample-Superstore.tsv |
awk 'BEGIN{FS="\t"}; {print $1}' | head -10
~~~
Penjelasan:
- `state1="Texas" state2="Illinois"` mendeklarasikan variable state1 dengan value "Texas" (didapat dari hasil b) dan state2 dengan value 
"Illinois" (yang juga didapat dari hasil b)
- Dalam block **BEGIN**
	- kurang lebih sama dengan yang sebelumnya, yang berbeda terdapat `OFS="\t"` yang berarti batas antar kolom pada output adalah tab
- Dalam block **body**
	- `($11~state1 || $11~state2)` mencari pattern pada kolom 11 yang memiliki data sama dengan state1 (Texas) atau state2 (Illinois)
	- `{produk[$17]+=$21}` mengisi array produk dengan jumlah "profit" (kolom 21) di mana index array produk adalah data pada kolom 17
- Dalam block **END**
	- `for(i in produk) print i, produk[i]` iterasi array produk dengan i sebagai indexnya, lalu mencetak semua index dan isi dari array
- `Sample-Superstore.tsv | awk 'BEGIN{FS="\t"}; {print $1}' | head -10`
	- `awk 'BEGIN{FS="\t"}` artinya data yang diinput (dalam hal ini merupakan output dari perintah sebelumnya) menggunakan "tab" sebagai pembatas kolom.
	- `head -10` menampilkan 10 row teratas

#### Hasil
![output_soal1](https://github.com/neutralix/SoalShiftSISOP20_modul1_F06/blob/master/output_soal1.png)


## Soal 2
Pada suatu siang, laptop Randolf dan Afairuzr dibajak oleh seseorang dan kehilangan data-data penting.
Untuk mencegah kejadian yang sama terulang kembali mereka
meminta bantuan kepada Whits karena dia adalah seorang yang punya banyak ide.
Whits memikirkan sebuah ide namun dia meminta bantuan kalian kembali agar ide
tersebut cepat diselesaikan.

### a. Membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka / b. Password acak tersebut disimpan pada file berekstensi .txt dengan nama berdasarkan argumen yang diinputkan dan HANYA berupa alphabet.

#### Penyelesaian
Menggunakan command untuk melakukan random generate character dan disimpan ke sebuah file dengan nama sesuai argumen yang diterima.
~~~
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1 > "$1".txt
~~~
Penjelasan:
- `cat` digunakan untuk menampilkan isi file, dalam kasus ini isi file berasal dari command /dev/urandom.
- `/dev/urandom` digunakan untuk memanggil perintah yang dapat me-random karakter secara pseudorandom.
- `tr -dc 'a-zA-Z0-9'` mengatur agar karakter yang di-random merupakan alfabet dan angka.
- `fold -w 28` jumlah karakter yang di-random sepanjang 28 karakter.
- `head -n 1` membuat satu baris string random.
- `> "$1".txt` melakukan redirection (menyimpan output ke file) dengan nama sesuai argumen.

### b. 

#### Penyelesaian
Menggunakan command untuk melakukan random generate character dan disimpan ke sebuah file dengan nama sesuai argumen yang diterima.
~~~
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1 > "$1".txt
~~~
Penjelasan:
- `cat` digunakan untuk menampilkan isi file, dalam kasus ini isi file berasal dari command /dev/urandom.
- `/dev/urandom` digunakan untuk memanggil perintah yang dapat me-random karakter secara pseudorandom.
- `tr -dc 'a-zA-Z0-9'` mengatur agar karakter yang di-random merupakan alfabet dan angka.
- `fold -w 28` jumlah karakter yang di-random sepanjang 28 karakter.
- `head -n 1` membuat satu baris string random.
- `> "$1".txt` melakukan redirection (menyimpan output ke file) dengan nama sesuai argumen.


## Soal 3
Pa

### a. Membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka.

#### Penyelesaian
Menggunakan command untuk melakukan random generate character dan disimpan ke sebuah file dengan nama sesuai argumen yang diterima.
~~~
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1 > "$1".txt
~~~
Penjelasan:
- Da
