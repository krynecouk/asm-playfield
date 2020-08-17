    processor 6502
    
    include "vcs.h"
    include "macro.h"
    
    seg code
    org $F000

Start:  
    CLEAN_START

    ldx #$80                    ; NTSC blue
    stx COLUBK                  ; background

    lda #$C8                    ; NTSC green
    sta COLUPF                  ; playerfield

NextFrame: 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Vertical Sync
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #%10
    sta VSYNC
    sta VBLANK
    
    sta WSYNC
    sta WSYNC
    sta WSYNC

    lda #0
    sta VSYNC
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Vertical Blank
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #37
VBlankLoop:
    sta WSYNC
    dex
    bne VBlankLoop

    lda #0
    stx VBLANK
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Set playerfield reflection
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #%1
    stx CTRLPF
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Print blank line
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #0
    stx PF0
    stx PF1
    stx PF2

BlankLineLoop:  
    REPEAT 7
        stx WSYNC
    REPEND
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Print upper border
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        stx WSYNC
    REPEND
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Print main area
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #%01100000
    stx PF0
    ldx #0
    stx PF1
    ldx #%10000000
    stx PF2

    ldx #164
MainAreaLoop:
    stx WSYNC
    dex
    bne MainAreaLoop
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Print lower border
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        stx WSYNC
    REPEND
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Print blank line
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        stx WSYNC
    REPEND
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Overscan
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #%10
    sta VBLANK

    ldx #30
OverscanLoop:    
    sta WSYNC
    dex
    bne OverscanLoop

    lda #0
    sta VBLANK
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Jump to next frame
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jmp NextFrame
    
    org $FFFC
    .word Start
    .word Start
