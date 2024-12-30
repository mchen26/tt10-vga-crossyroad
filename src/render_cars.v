//SPDX-FileCopyrightText: 2025 Matthew Chen, Jovan Koledin, and Ryan Leahy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
`default_nettype none

// Calculate X-position for car obstacles
module rendering (
    output wire pixel,
    output wire collision,
    output reg [2:0] car_select,

    input wire game_over,
    input wire game_start_blink,
    input wire score_pixel,
    
    input wire [2:0] car_type,
    input wire [9:0] vaddr,
    input wire [9:0] haddr,
    input wire [10:0] scrolladdr,

    input wire clk,
    input wire sys_rst
);
