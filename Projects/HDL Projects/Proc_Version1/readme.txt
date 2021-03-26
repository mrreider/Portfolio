Verilog implementation of WISC-SP13 ISA Unpipelined. Will be implementing pipeline soon.

Specification: http://pages.cs.wisc.edu/~karu/courses/cs552/spring2021/wiki/index.php/Main/ISASpecification

In this class we must adhere to constraining Verilog rules with the intention of forcing us to "think like hardware." We are limited to low level operators and constructs. For example, instead of simply using the '+' operator, we must implement our own 16 bit CLA.

This is different from the other HDL projects in this repository (UART, SPI) as the others allow unrestricted use of SystemVerilog.

Some modules, such as DFF or memory2c were provided by the UW Madison ECE department and are credited properly.