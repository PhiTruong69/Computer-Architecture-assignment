<h1 align="center">🖥️ Computer Architecture Assignment</h1>

<p align="center">
  <em>Đề tài: Nhân 2 số thực chuẩn IEEE 754 chính xác đơn (Single Precision)</em><br>
  <sub>Trường Đại học Bách Khoa - ĐHQG TP.HCM</sub>
</p>

---

<h2>📖 Giới thiệu</h2>
<p>
Dự án này hiện thực chương trình <b>nhân hai số thực theo chuẩn IEEE 754 dạng chính xác đơn (32-bit)</b> 
mà không sử dụng các lệnh tính toán số thực trong MIPS. 
Dữ liệu đầu vào được đọc từ file nhị phân <code>FLOAT2.BIN</code> (2 số thực, mỗi số 4 byte).
</p>

---

<h2>⚙️ Giải pháp hiện thực</h2>
<ol>
  <li>Tách số thực thành <b>bit dấu (Sign)</b>, <b>Exponent</b> và <b>Fraction</b>.</li>
  <li>Thực hiện nhân hai số theo công thức IEEE 754:
    <pre>X3 = (−1)<sup>S1+S2</sup> × (1+F1) × (1+F2) × 2^(E1+E2−bias)</pre>
  </li>
  <li>Chuẩn hóa kết quả (normalize) và điều chỉnh mũ nếu cần.</li>
  <li>Xử lý các trường hợp đặc biệt: <i>overflow</i>, <i>underflow</i>, nhân với 0.</li>
  <li>Xuất kết quả dưới dạng số thực (decimal) và nhị phân (IEEE 754 format).</li>
</ol>

---

<h2>🛠️ Hiện thực chương trình</h2>
<p>
Chương trình được viết bằng <b>Assembly MIPS</b>, chạy trên môi trường mô phỏng (MARS/SPIM). 
Quy trình thực hiện:
</p>
<ul>
  <li>Đọc dữ liệu từ file nhị phân <code>FLOAT2.BIN</code>.</li>
  <li>Tách và xử lý các trường bit.</li>
  <li>Tính toán kết quả nhân theo chuẩn IEEE 754.</li>
  <li>In kết quả ra màn hình (số thực và nhị phân).</li>
</ul>

---

<h2>📊 Đánh giá</h2>
<p>
Thời gian thực thi được đo bằng công thức:
<pre>CPU_time = (IC × CPI) / ClockRate</pre>
</p>

<ul>
  <li>Trường hợp nhanh nhất: nhân với 0 (~55ns).</li>
  <li>Trường hợp chậm nhất: ~134ns.</li>
  <li>Khi input quá lớn/nhỏ có thể gây <i>overflow</i> hoặc <i>underflow</i>.</li>
</ul>

---

<h2> Tài liệu tham khảo</h2>
<ol>
  <li><i>MIPS32™ Architecture For Programmers Volume II</i></li>
  <li><i>Computer Organization and Design: The Hardware/Software Interface</i> – David A. Patterson</li>
</ol>

---

<p align="center">
  <sub><em>Built with Phi Truong for Computer Architecture course</em></sub>
</p>
