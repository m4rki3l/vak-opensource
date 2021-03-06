--------------------------------------------------------------------------
--
--  Copyright (C) 1993, Peter J. Ashenden
--  Mail:	Dept. Computer Science
--		University of Adelaide, SA 5005, Australia
--  e-mail:	petera@cs.adelaide.edu.au
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 1, or (at your option)
--  any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--
--------------------------------------------------------------------------
--
--  $RCSfile: dlx_test-bench.vhdl,v $  $Revision: 2.1 $  $Date: 1993/10/31 22:40:43 $
--
--------------------------------------------------------------------------
--
--  Architecture for test bench for DLX,
--  consisting of clock generator, memory and bus_monitor
--


use std.textio.all,
    work.dlx_types.all, work.mem_types.all;

architecture bench of dlx_test is

  component clock_gen
    port (phi1, phi2 : out bit;
      	  reset : out bit);
  end component;
  
  component memory
    port (phi1, phi2 : in bit;
      	  a : in dlx_address;
	  d : inout dlx_word_bus bus;
	  width : in mem_width;
	  write_enable : in bit;
          burst : in bit := '0';
	  mem_enable : in bit;
	  ready : out bit);
  end component;
  
  component dlx
    port (phi1, phi2 : in bit;		  -- 2-phase non-overlapping clocks
          reset : in bit;		  -- synchronous reset input
          a : out dlx_address;		  -- address bus output
	  d : inout dlx_word_bus bus;	  -- bidirectional data bus
	  halt : out bit;		  -- halt indicator
	  width : out mem_width;	  -- byte/haldword/word indicator
	  write_enable : out bit;	  -- selects read or write cycle
	  mem_enable : out bit;		  -- starts memory cycle
	  ifetch : out bit;		  -- indicates instruction fetch
	  ready : in bit);		  -- status from memory system
  end component;

  component dlx_bus_monitor
    port (phi1, phi2 : in bit;		  -- 2-phase non-overlapping clocks
      	  reset : in bit;		  -- synchronous reset
      	  a : in dlx_address;		  -- address bus
	  d : in dlx_word;	  	  -- data bus
	  halt : in bit;		  -- halt indicator
	  width : in mem_width;		  -- byte/haldword/word indicator
	  write_enable : in bit;	  -- selects read or write cycle
          burst : in bit := '0';          -- indicates more to come in burst
	  mem_enable : in bit;		  -- starts memory cycle
	  ifetch : in bit;		  -- indicates instruction fetch
	  ready : in bit);		  -- status from memory system
  end component;

  signal phi1, phi2, reset : bit;
  signal a : dlx_address;
  signal d : dlx_word_bus bus;
  signal halt : bit;
  signal width : mem_width;
  signal write_enable, mem_enable, ifetch, ready : bit;
  
begin

  cg : clock_gen
    port map (phi1, phi2, reset);
    
  mem : memory
    port map (phi1, phi2, a, d, width, write_enable, open, mem_enable, ready);
    
  proc : dlx
    port map (phi1, phi2, reset, a, d, 
      	      halt, width, write_enable, mem_enable, ifetch, ready);

  bus_monitor : dlx_bus_monitor
    port map (phi1, phi2, reset, a, d, 
      	      halt, width, write_enable, open, mem_enable, ifetch, ready);

end bench;
