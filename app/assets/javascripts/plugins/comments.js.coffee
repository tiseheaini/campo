$(document).on 'click', '.comment [data-reply-to]', ->
  if $('#new_comment .simditor').length != 0
    # 自己写得苦涩实现方法
    # window.editor.focus();
    # div = window.editor.body.find('p:eq(-1)')[0]
    # range = document.createRange()
    # len = window.editor.getValue().length
    # range.setStart(div, 1)
    # range.setEnd(div, 1)
    # getSelection().addRange(range)
    window.comment_editor.setValue( window.comment_editor.getValue() + $(this).data('reply-to') )
    last = window.comment_editor.body.find('p, li, pre, h1, h2, h3, h4, td').last();
    window.comment_editor.focus();
    window.comment_editor.selection.setRangeAfter(last);
  else
    textarea = $('#comment-editor #comment_body')
    textarea.focus()
    textarea.val(textarea.val() + $(this).data('reply-to'))
