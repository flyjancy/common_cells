## UART

`uart_top` : 顶层模块

`clk_div`  : 分频时钟，当波特率为115200时参数应设为434（50M/434 = 115207）

`uart_rx`  : 通过shift reg实现16倍采样，判断起始位后开始计数，计数通过cnt_en和clk_uart两个信号控制，计满后又再次开始。

`uart_tx`  : 读keyboard module的start信号，开始发送数据

`keyboard` : 按键消抖

`data_generator` : 就是一个简单的计数器，用于测试uart_tx