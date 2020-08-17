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
    
    REPEAT 3
        sta WSYNC
    REPEND

    lda #0
    sta VSYNC
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Vertical Blank
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #%10

    REPEAT 37
        sta WSYNC
    REPEND

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
    ldx #%00100000
    stx PF0
    ldx #0
    stx PF1
    stx PF2
    REPEAT 164
        stx WSYNC
    REPEND
    
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
    REPEAT 30
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Jump to next frame
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jmp NextFrame
    
    org $FFFC
    .word Start
    .word Start
