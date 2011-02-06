" ============================================================================
" File:        vimlocalmacros - Store and execute macros in current file.
" Description: Allows macros to be stored using the current file's comments.
" Author:      Barry Arthur <barry dot arthur at gmail dot com>
" Last Change: 6 February, 2011
" Website:     http://github.com/dahu/VimLocalMacros
"
" See vimlocalmacros.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help vimlocalmacros
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let s:VimLocalMacros = '0.0.1'  " alpha, unreleased

" Vimscript setup {{{1
let s:old_cpo = &cpo
set cpo&vim

" Public Interface {{{1
function! WriteMacro(macro)
  call setline('.', [printf(&commentstring,printf('vlm:let @%s="%s"',a:macro,escape(substitute(getreg(a:macro),"\<Esc>",'\\<Esc>','g'), '"')))])
endfunction

function! RunMacroLine()
  let line = getline('.')
  let vlmm = '^\s*'.substitute(escape(&commentstring, '[]^$*.{}\'), '%s', 'vlm:\\(.*\\)', '')
  let vlml = ''
  silent! let vlml = matchlist(line, vlmm)[1]
  if vlml != ''
    exe vlml
  else
    echo "Not a vlm line."
  endif
endfunction

" Maps {{{1
" TODO: add clash and override checks
nnoremap <leader>mw :call WriteMacro(input("Register? "))<CR>
nnoremap <leader>mr :call RunMacroLine()<CR>

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:old_cpo

" vim: set sw=2 sts=2 et fdm=marker:
