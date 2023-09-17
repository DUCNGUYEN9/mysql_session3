-- Bài 1: Tạo CSDL QUANLYBANHANG
create database quanlibanhang;
use quanlibanhang;
create table khachhang(
	makh nvarchar(4) primary key,
    tenkh nvarchar(30) not null,
    diachi nvarchar(50),
    ngaysinh datetime,
    sodt nvarchar(15) unique
);
create table nhanvien(
	manv nvarchar(4) primary key,
    hoten nvarchar(30) not null,
    gioitinh bit,
    diachi nvarchar(50) not null,
    ngaysinh datetime not null,
    dienthoai nvarchar(15),
    email text,
    noisinh nvarchar(20) not null,
    ngayvaolam datetime,
    manql nvarchar(4)
);
create table nhacungcap(
	mancc nvarchar(5) primary key,
    tenncc nvarchar(50) not null,
    diachi nvarchar(50) not null,
    dienthoai nvarchar(15) not null,
    email nvarchar(30) not null,
    website nvarchar(30)
);
create table loaisp(
	maloaisp nvarchar(4) primary key,
    tenloaisp nvarchar(30) not null,
    ghichu nvarchar(100) not null
);
create table sanpham(
	masp nvarchar(4) primary key,
    maloaisp nvarchar(4) not null,
    tensp nvarchar(50) not null,
    donvitinh nvarchar(10) not null,
    ghichu nvarchar(100)
);
create table phieunhap(
	sopn nvarchar(5) primary key,
    manv nvarchar(4) not null,
    mancc nvarchar(5) not null,
    ngaynhap datetime,
    ghichu nvarchar(100)
);
create table ctphieunhap(
	masp nvarchar(4),
    -- thêm khóa ngoại
    foreign key (masp) references sanpham(masp),
    sopn nvarchar(5),
    foreign key (sopn) references phieunhap(sopn),
    primary key (masp,sopn),
    soluong int default 0,
    gianhap real not null check (gianhap >= 0) 
);
create table phieuxuat(
	sopx nvarchar(5) primary key,
    manv nvarchar(4) not null,
    makh nvarchar(4) not null,
    ngayban datetime default current_timestamp,
    ghichu text
);
create table ctphieuxuat(
	sopx nvarchar(5),
    -- thêm khóa ngoại
    foreign key(sopx) references phieuxuat(sopx),
    masp nvarchar(4),
    foreign key(masp) references sanpham(masp),
    primary key(sopx,masp),
    soluong smallint not null check(soluong > 0),
    giaban real not null check (giaban > 0)
);
-- Bài 2: Dùng câu lệnh ALTER để thêm rằng buộc khóa ngoại còn lại
alter table phieunhap
add foreign key(manv) references nhanvien(manv);
alter table phieunhap
add foreign key(mancc) references nhacungcap(mancc);
alter table phieuxuat
add foreign key(manv) references nhanvien(manv);
alter table phieuxuat
add foreign key(makh) references khachhang(makh);
alter table sanpham
add foreign key(maloaisp) references loaisp(maloaisp);
-- Bài 3: Dùng lệnh INSERT thêm dữ liệu vào các bảng
insert into nhacungcap
values  ('NCC01','CHANNEL','TOKYO','0123456789','channel@gmail.com','channel.com'),
		('NCC02','DIOR','FRANCE','0987654321','dior@gmail.com','dior.com');
insert into nhanvien
values  ('NV01','Ngoc Duc',1,'Tokyo','1996-01-01','0123456789','ngocduc@gmail.com','Viet Nam','2023-01-01','QL01'),
		('NV02','Duc Nguyen',1,'Fukuoka','1996-10-10','0987654321','ducnguyen@gmail.com','Nhat Ban','2023-01-01','QL02');
-- 1. Thêm 2 Phiếu nhập trong tháng hiện hành. Mỗi phiếu nhập có 2 sản phẩm
insert into phieunhap
values  ('PN001','NV01','NCC01','2023-09-14','Phiếu nhập 1'),
		('PN002','NV02','NCC02','2023-09-14','Phiếu nhập 2');
insert into ctphieunhap
values  ('SP01','PN002',0,12000),
		('SP02','PN001',3,32000) ;
insert into loaisp
values  ('LSP1','Nước Hoa','channel 1'),
		('LSP2','T-shirt','T-Shirt white');
insert into sanpham
values  ('SP01','LSP1','Nước Hoa A','ml','nhập khẩu'),
		('SP02','LSP1','Nước Hoa B','ml','nhập khẩu'),
        ('SP03','LSP2','T-shirt W','M','nhập khẩu'),
		('SP04','LSP2','T-shirt WB','XL','nhập khẩu');
insert into khachhang
values  ('KH01','Nguyen Văn A','Tokyo','1996-11-01','0987654321'),
		('KH02','Nguyen Ngoc B','Osaka','1996-12-01','0988787877'),
        ('KH03','Nguyen Duc C','Hokkaido','1996-05-01','09987878712');
-- 2. Thêm 2 Phiếu xuất trong ngày hiện hành. Mỗi phiếu xuất có 3 sản phẩm.
insert into phieuxuat
values  ('PX001','NV01','KH01','2023-09-14','nuoc hoa'),
        ('PX002','NV02','KH02','2023-09-14','t-shirt');
insert into ctphieuxuat
values  ('PX001','SP01','1','12000'),
		('PX001','SP02','3','20000'),
		('PX001','SP04','2','12000'),
		('PX002','SP03','4','15000'),
		('PX002','SP01','1','13000'),
        ('PX002','SP04','3','9000');
-- 3. Thêm 1 nhân viên mới
insert into nhanvien
values  ('NV03','Nguyen Duc',1,'Ha Noi','1995-11-01','0123456789','ngocduc123@gmail.com','Viet Nam','2022-12-01','QL01');
insert into nhanvien
values	('NV04','Ngoc Nguyen',1,'Ho Chi Minh','1997-09-02','0123456789','ngocduc456@gmail.com','Viet Nam','2022-09-01','QL01');

-- Bài 4: Dùng lệnh UPDATE cập nhật dữ liệu các bảng
-- Cập nhật lại số điện thoại mới cho khách hàng KH01
update khachhang
set sodt = '0919191919'
where makh = 'KH01';
-- Cập nhật lại địa chỉ mới của nhân viên mã NV01
update nhanvien
set diachi = 'Binh Thuan'
where manv = 'NV01';

-- Bài 5: Dùng lệnh DELETE xóa dữ liệu các bảng
-- Xóa nhân viên mới vừa thêm
delete from nhanvien
where manv = 'NV03';
-- Xóa sản phẩm mã SP05
insert into sanpham
values  ('SP05','LSP1','Nước Hoa Z','ml','nhập khẩu A');
delete from sanpham
where masp = 'SP05';

-- Bài 6: Dùng lệnh SELECT lấy dữ liệu từ các bảng
/*
1. Liệt kê thông tin về nhân viên trong cửa hàng, gồm: mã nhân viên, họ tên 
nhân viên, giới tính, ngày sinh, địa chỉ, số điện thoại, tuổi. Kết quả sắp xếp 
theo tuổi.
*/ 
select nv.manv, nv.hoten, nv.gioitinh, nv.ngaysinh, nv.diachi, nv.dienthoai, (year(curdate())-year(nv.ngaysinh)) as 'Age'
from nhanvien as nv order by nv.ngaysinh asc;
/*
2. Liệt kê các hóa đơn nhập hàng trong tháng 6/2018, gồm thông tin số phiếu 
nhập, mã nhân viên nhập hàng, họ tên nhân viên, họ tên nhà cung cấp, ngày
nhập hàng, ghi chú.
*/
select pn.sopn, pn.manv,nv.hoten, ncc.tenncc, pn.ngaynhap, pn.ghichu
from phieunhap as pn join nhacungcap ncc on pn.mancc = ncc.mancc
					 join nhanvien nv on pn.manv = nv.manv;
/*
3. Liệt kê tất cả sản phẩm có đơn vị tính là chai, gồm tất cả thông tin về sản 
phẩm.
*/
select * from sanpham as sp where sp.donvitinh = 'chai';
/*
4. Liệt kê chi tiết nhập hàng trong tháng hiện hành gồm thông tin: số phiếu 
nhập, mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính, số lượng, giá 
nhập, thành tiền.
*/
select ctpn.sopn, ctpn.masp, sp.tensp, sp.maloaisp, sp.donvitinh,  ctpn.soluong, ctpn.gianhap
from ctphieunhap as ctpn join sanpham as sp on ctpn.masp = sp.masp ;
/*
5. Liệt kê các nhà cung cấp có giao dịch mua bán trong tháng hiện hành, gồm 
thông tin: mã nhà cung cấp, họ tên nhà cung cấp, địa chỉ, số điện thoại, 
email, số phiếu nhập, ngày nhập. Sắp xếp thứ tự theo ngày nhập hàng.
*/
select ncc.mancc, ncc.tenncc, ncc.diachi, ncc.dienthoai, ncc.email, pn.sopn, pn.ngaynhap
from nhacungcap ncc join phieunhap pn on ncc.mancc = pn.mancc ;
/*
6. Liệt kê chi tiết hóa đơn bán hàng  
số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên sản phẩm, 
đơn vị tính, số lượng, giá bán, doanh thu.
*/

select px.sopx, nv.hoten, px.ngayban, ctpx.masp, sp.tensp, sp.donvitinh,
 ctpx.soluong, ctpx.giaban, (ctpx.soluong * ctpx.giaban) as 'doanh thu'
from phieuxuat px join nhanvien nv on px.manv = nv.manv
				  join ctphieuxuat ctpx on px.sopx = ctpx.sopx
                  join sanpham sp on ctpx.masp = sp.masp;
/*
7. Hãy in danh sách khách hàng có ngày sinh nhật trong tháng hiện hành (gồm 
tất cả thông tin của khách hàng)
*/
select * from khachhang kh where month(kh.ngaysinh) = month(curdate()) ;
/*
8. Liệt kê các hóa đơn bán hàng từ ngày 01/09/2023 đến 15/09/2023 gồm các 
thông tin: số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên 
sản phẩm, đơn vị tính, số lượng, giá bán, doanh thu.
*/
select ctpx.sopx, nv.hoten, px.ngayban, sp.masp, sp.tensp,
	sp.donvitinh, ctpx.soluong, ctpx.giaban, (ctpx.soluong * ctpx.giaban) as "doanh thu"
from ctphieuxuat ctpx inner join phieuxuat px on ctpx.sopx = px.sopx
					  inner join nhanvien nv on px.manv = nv.manv
                      inner join sanpham sp on ctpx.masp = sp.masp
where px.ngayban >= '2023-09-01' and px.ngayban <= '2023-09-15';
/*
9. Liệt kê các hóa đơn mua hàng theo từng khách hàng, gồm các thông tin: số 
phiếu xuất, ngày bán, mã khách hàng, tên khách hàng, trị giá.

*/
select px.sopx, px.ngayban, kh.makh, kh.tenkh, (ctpx.soluong * ctpx.giaban) as "tri gia"
from phieuxuat px inner join khachhang kh on px.makh = kh.makh
				  inner join ctphieuxuat ctpx on px.sopx = ctpx.sopx;
/*
10. Cho biết tổng số chai nước xả vải Comfort đã bán trong 6 tháng đầu năm 
2023. Thông tin hiển thị: tổng số lượng.
*/
select sum(ctpx.soluong) as "tổng số lượng"
from ctphieuxuat ctpx join sanpham sp on ctpx.masp = sp.masp
					  join phieuxuat px on ctpx.sopx = px.sopx
where sp.tensp = 'Nước Hoa A' and  px.ngayban between "2023-01-01" and  "2023-06-30";
/*
11.Tổng kết doanh thu theo từng khách hàng theo tháng, gồm các thông tin: 
tháng, mã khách hàng, tên khách hàng, địa chỉ, tổng tiền
*/
select month(px.ngayban) as "thang", kh.makh, kh.tenkh,
 kh.diachi, sum(ctpx.soluong * ctpx.giaban) as "tổng tiền"
from phieuxuat px join khachhang kh on px.makh = kh.makh
				  join ctphieuxuat ctpx on px.sopx = ctpx.sopx
group by month(px.ngayban),kh.makh, kh.tenkh, kh.diachi;
/*
12.Thống kê tổng số lượng sản phẩm đã bán theo từng tháng trong năm, gồm 
thông tin: năm, tháng, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số 
lượng.
*/
select year(px.ngayban) as "năm", month(px.ngayban) as "tháng",
 sp.masp, sp.tensp, sp.donvitinh, sum(ctpx.soluong) as "tổng số lượng"
from sanpham sp join ctphieuxuat ctpx on sp.masp = ctpx.masp
				join phieuxuat px on ctpx.sopx = px.sopx
group by year(px.ngayban), month(px.ngayban), sp.masp, sp.tensp, sp.donvitinh;
/*
13.Thống kê doanh thu bán hàng trong trong 6 tháng đầu năm 2023, thông tin 
hiển thị gồm: tháng, doanh thu
*/
select month(px.ngayban) as "thang", sum(ctpx.soluong * ctpx.giaban) as "doanh thu"
from phieuxuat px join ctphieuxuat ctpx on px.sopx = ctpx.sopx
where year(px.ngayban) = 2023 and month(px.ngayban) between 1 and 6
group by month(px.ngayban);

/*
14.Liệt kê các hóa đơn bán hàng của tháng 5 và tháng 6 năm 2023, gồm các 
thông tin: số phiếu, ngày bán, họ tên nhân viên bán hàng, họ tên khách hàng, 
tổng trị giá.
*/
select px.sopx, px.ngayban, nv.hoten, kh.tenkh, sum(ctpx.soluong * ctpx.giaban) as "tổng trị giá"
from phieuxuat px join nhanvien nv on px.manv = nv.manv
				  join khachhang kh on px.makh = kh.makh
                  join ctphieuxuat ctpx on px.sopx = ctpx.sopx
where year(px.ngayban) = 2023 and month(px.ngayban) in (5,6)
group by px.sopx, px.ngayban, nv.hoten, kh.tenkh;
/*
15.Cuối ngày, nhân viên tổng kết các hóa đơn bán hàng trong ngày, thông tin 
gồm: số phiếu xuất, mã khách hàng, tên khách hàng, họ tên nhân viên bán 
hàng, ngày bán, trị giá.
*/
select px.sopx, kh.makh, kh.tenkh, nv.hoten, px.ngayban,
 sum(ctpx.soluong * ctpx.giaban) as "tri gia"
from phieuxuat px join nhanvien nv on px.manv = nv.manv
				  join khachhang kh on px.makh = kh.makh
                  join ctphieuxuat ctpx on px.sopx = ctpx.sopx
where date(px.ngayban) = current_date
group by px.sopx, kh.makh, kh.tenkh, nv.hoten, px.ngayban ;
/*
16.Thống kê doanh số bán hàng theo từng nhân viên, gồm thông tin: mã nhân 
viên, họ tên nhân viên, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số 
lượng.
*/
select nv.manv, nv.hoten, sp.masp, sp.tensp, sp.donvitinh, 
sum(ctpx.soluong) as "tổng số lượng"
from nhanvien nv join phieuxuat px on nv.manv = px.manv
				 join ctphieuxuat ctpx on px.sopx = ctpx.sopx
                 join sanpham sp on ctpx.masp = sp.masp
group by nv.manv, nv.hoten, sp.masp, sp.tensp, sp.donvitinh ;
/*
17.Liệt kê các hóa đơn bán hàng cho khách vãng lai (KH01) trong quý 2/2023, 
thông tin gồm số phiếu xuất, ngày bán, mã sản phẩm, tên sản phẩm, đơn vị 
tính, số lượng, đơn giá, thành tiền.
*/
select px.sopx, px.ngayban, sp.masp, sp.tensp, sp.donvitinh,
 ctpx.soluong, ctpx.giaban, sum(ctpx.soluong * ctpx.giaban) as "thành tiền"
from phieuxuat px join ctphieuxuat ctpx on px.sopx = ctpx.sopx
				  join khachhang kh on px.makh = kh.makh
                  join sanpham sp on ctpx.masp = sp.masp
where kh.makh = "KH01" and year(px.ngayban) = 2023 and month(px.ngayban) in (4,5,6) 
group by px.sopx, px.ngayban, sp.masp, sp.tensp, sp.donvitinh, ctpx.soluong, ctpx.giaban ;
/*
18.Liệt kê các sản phẩm chưa bán được trong 6 tháng đầu năm 2018, thông tin 
gồm: mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính. 
*/
select sp.masp, sp.tensp, lsp.tenloaisp, sp.donvitinh
from sanpham sp join loaisp lsp on sp.maloaisp = lsp.maloaisp
where sp.masp not in (
select ctpx.masp
from ctphieuxuat ctpx join phieuxuat px on ctpx.sopx = px.sopx
where year(px.ngayban) = 2023 and month(px.ngayban) between 1 and 6
);
/*
19.Liệt kê danh sách nhà cung cấp không giao dịch mua bán với cửa hàng trong 
quý 2/2023, gồm thông tin: mã nhà cung cấp, tên nhà cung cấp, địa chỉ, số 
điện thoại.
*/
select ncc.mancc, ncc.tenncc, ncc.diachi, ncc.dienthoai
from phieunhap pn join nhacungcap ncc on pn.mancc= ncc.mancc
				  join ctphieunhap ctpn on ctpn.sopn = pn.sopn
where ctpn.soluong = 0 and year(pn.ngaynhap) = 2023 and month(pn.ngaynhap) between 1 and 9 ;
/*
20.Cho biết khách hàng có tổng trị giá đơn hàng lớn nhất trong 6 tháng đầu năm 
2023. 
*/
select kh.tenkh, max(ctpx.soluong * ctpx.giaban) as "tổng trị giá"
from khachhang kh join phieuxuat px on kh.makh = px.makh
				  join ctphieuxuat ctpx on px.sopx = ctpx.sopx
where year(px.ngayban) = 2023 and month(px.ngayban) between 1 and 6
group by kh.tenkh ;
/*
21.Cho biết mã khách hàng và số lượng đơn đặt hàng của mỗi khách hàng
*/
select kh.makh, count(px.sopx) as "số lượng đơn đặt hàng"
from khachhang kh join phieuxuat px on kh.makh = px.makh
group by kh.makh ;
/*
22.Cho biết mã nhân viên, tên nhân viên, tên khách hàng kể cả những nhân viên 
không đại diện bán hàng
*/
select nv.manv, nv.hoten, kh.tenkh
from nhanvien nv  left join phieuxuat px on nv.manv = px.manv
				  left join khachhang kh on px.makh = kh.makh ;
/*
23.Cho biết số lượng nhân viên nam, số lượng nhân viên nữ
*/
select sum(nv.gioitinh = 1) as "số lượng nhân viên nam" , 
	   sum(nv.gioitinh = 0) as "số lượng nhân viên nữ" 
from nhanvien nv;
/*
24.Cho biết mã nhân viên, tên nhân viên, số năm làm việc của những nhân viên 
có thâm niên cao nhất
*/
select nv.manv, nv.hoten, max(year(now()) - year(nv.ngayvaolam)) as "số năm làm việc"
from nhanvien nv
group by nv.manv, nv.hoten 
having max(year(now()) - year(nv.ngayvaolam)) = (
    select max(year(now()) - year(ngayvaolam)) 
    from nhanvien
) ;

/*
25.Hãy cho biết họ tên của những nhân viên đã đến tuổi về hưu (nam:60 tuổi, 
nữ: 55 tuổi)
*/
select nv.hoten
from nhanvien nv
where (nv.gioitinh = 1 and year(now()) - year(nv.ngaysinh) >=60) or
	  (nv.gioitinh = 0 and year(now()) - year(nv.ngaysinh) >=55);
/*
26.Hãy cho biết họ tên của nhân viên và năm về hưu của họ. 
*/
select nv.hoten, 
		case
        when nv.gioitinh = 1 then (60 - (year(now()) - year(nv.ngaysinh)) +year(now()) )
        when nv.gioitinh = 0 then (55 - (year(now()) - year(nv.ngaysinh)) + year(now()) )
		end as "năm về hưu"
from nhanvien nv
where (nv.gioitinh = 1 and year(now()) - year(nv.ngaysinh) < 60) or
	  (nv.gioitinh = 0 and year(now()) - year(nv.ngaysinh) < 55);
/*
27.Cho biết tiền thưởng tết dương lịch của từng nhân viên. Biết rằng - thâm 
niên <1 năm thưởng 200.000 - 1 năm <= thâm niên < 3 năm thưởng 
400.000 - 3 năm <= thâm niên < 5 năm thưởng 600.000 - 5 năm >= thâm 
niên < 10 năm thưởng 800.000 - thâm niên >= 10 năm thưởng 1.000.000
*/
select nv.hoten, (
case
 when year(now()) - year(nv.ngayvaolam) < 1 then 200.000
 when year(now()) - year(nv.ngayvaolam) between 1 and 2 then 400.000
 when year(now()) - year(nv.ngayvaolam) between 3 and 4 then 600.000
 when year(now()) - year(nv.ngayvaolam) between 5 and 9 then 800.000
 when year(now()) - year(nv.ngayvaolam) >= 10 then 1000.000
 end 
) as "tiền thưởng tết"
from nhanvien nv;
/*
28.Cho biết những sản phẩm thuộc ngành hàng Hóa mỹ phẩm
*/
select sp.tensp
from loaisp lsp join sanpham sp on lsp.maloaisp = sp.maloaisp
where lsp.tenloaisp = "Hóa mỹ phẩm";
/*
29.Cho biết những sản phẩm thuộc loại Quần áo.
*/
select sp.tensp
from loaisp lsp join sanpham sp on lsp.maloaisp = sp.maloaisp
where lsp.tenloaisp = "Quần áo";
/*
30.Cho biết số lượng sản phẩm loại Quần áo.
*/
select count(ctpn.soluong) as "số lượng"
from loaisp lsp join sanpham sp on lsp.maloaisp = sp.maloaisp
				join ctphieunhap ctpn on sp.masp = ctpn.masp
where lsp.tenloaisp = "Quần áo";

/*
31.Cho biết số lượng loại sản phẩm ngành hàng Hóa mỹ phẩm
*/
select count(lsp.maloaisp) as "Số lượng"
from loaisp lsp
where lsp.tenloaisp = "Hóa mỹ phẩm";

/*
32.Cho biết số lượng sản phẩm theo từng loại sản phẩm
*/
select lsp.tenloaisp,count(sp.masp) as "số lượng"
from loaisp lsp join sanpham sp on lsp.maloaisp = sp.maloaisp
group by lsp.tenloaisp;