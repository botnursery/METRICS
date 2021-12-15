`timescale 1ns / 1ps
// QMTech® Cyclone IV Starter Kit uses Intel(Altera) EP4CE15F23 //v.1bis
module blockpitcher (
					clk,           // Входные часы на доске разработки: 50Mhz - T2
					rst_n,         // Нажмите кнопку сброса на плате разработки - J4
					ask,				// Запрос данных
					result,			// Хеш найден
					led,				// Выходной светодиодный индикатор для управления платой разработки LED - E3
					start,			// Старт цикла
					out				// Данные
);

//===========================================================================
// PORT declarations
//===========================================================================
input clk;
input rst_n;
input ask;
input result;
output led;
output start;
output[31:0] out;

//===========================================================================
// Счетчик: счетчик циклов 0 ~ 2s
//===========================================================================
// Определение регистра счетчика времени
reg [31:0] timer;                  
reg led;

  always @(posedge clk or negedge rst_n)    //Обнаружение подъема и сброса часов
    begin
      if (~rst_n)                           //Сигнал сброса неэффективен
          timer <= 0;                       //Счетчик равен нулю
      else if (timer == 32'd99_999_999)     //Кристаллическая вибрация составляет 50 МГц, 2 секунды (50M*2-1=99_999_999)
          timer <= 0;                       //Счетчик 2 секунды, счетчик сбрасывается
      else
		    timer <= timer + 1'b1;            //Счетчик увеличивается на 1
    end

//===========================================================================
// LED Управление светом
//===========================================================================
 always @(posedge clk or negedge rst_n)   //Обнаружение подъема и сброса часов
    begin
      if (~rst_n)                          //Сигнал сброса неэффективен (по низкому уровню)
          led <= 1'b1;                  	 //LED Светодиодный индикатор выходного сигнала высокий (не горит)
      else if (timer == 32'd4_999_999)    //Счетчик составляет 1 секунд,
          led <= 1'b0;                     //LED Светодиод горит
      else if (timer == 32'd99_999_999)    //Счетчик составляет 2 секунда,
          led <= 1'b1;                     //LED Светодиодный индикатор выключен
    end

//=======================================================
// One-count lock w D trigger bounce free out
//=======================================================
wire D;		// Data input const = 0
wire led1;	// output one-count led1 - дребезг кончился через 100ms (timer == 32'd4_999_999)

reg Q;		// trigger output Q

assign D =	1'h0;
assign led1 = (Q&&led);

always @(negedge led or negedge rst_n)
begin
 if(~rst_n)
  Q <= 1'b1; 
 else 
  Q <= D; 
end

//=======================================================
// one-shot multivibrators 1 clk tacts count
// monostable for first led1 Flip-Flop with Synchronous Reset
//=======================================================
wire next; // Next cycle = 1 //assign next =	1'h0; // golden hesh

reg one_shot1;
reg [1:0] counter1;

always @(negedge clk) begin
	if(led1&&next) begin
		counter1=2'b00;
		one_shot1=1'b0;
		end
	else	begin
			if (counter1==2'b01) begin
				counter1=2'b01;
				one_shot1=1'b0;
				end
			else begin
				counter1=counter1+2'b01;
				one_shot1=1'b1;
				end
			end
end
assign start = ~one_shot1;

//=======================================================
// counter up to 3 for address
//=======================================================
wire [1:0] addr;

reg [1:0] cnt_addr;

always @(posedge ask or negedge start)
	begin
		if (~start)
          cnt_addr <= 0;
		else if (cnt_addr == 2'b10)
          cnt_addr <= 0;
		else
		    cnt_addr <= cnt_addr + 1'b1;
	end

assign addr = cnt_addr;

//=======================================================
// counter up to 2 for comparator
//=======================================================
wire comp;

reg [1:0] cnt_comp;

always @(posedge clk or negedge start) // два такта после третьего аска
	begin
		if (~start)
          cnt_comp <= 0;
		else if (cnt_comp == 2'b10)
          cnt_comp <= 0;
		else if (cnt_addr == 2'b10)
		    cnt_comp <= cnt_comp + 1'b1;
	end

assign comp = ~cnt_comp[1];

//=======================================================
// memory ROM
//=======================================================
reg [31:0] out;
reg [31:0] rom_data[2:0];

always @(posedge clk)
begin
	rom_data[0]=32'hAAAAAAAA;
	rom_data[1]=32'h11111111;
	rom_data[2]=32'h0000FFFF;
	out=rom_data[addr];
end

//=======================================================
// compare for next
//=======================================================

assign next = result&&comp;

endmodule

/*

*/