import {basicSetup} from "codemirror"
import {EditorView, keymap} from "@codemirror/view"
import {indentMore, indentLess} from "@codemirror/commands"
import {ruby} from '@codemirror/legacy-modes/mode/ruby'
import {html} from '@codemirror/lang-html'
import {markdown} from '@codemirror/lang-markdown'
import {completionStatus, acceptCompletion} from '@codemirror/autocomplete'
import {tags} from "@lezer/highlight"

import {
    StreamLanguage,
    HighlightStyle,
    defaultHighlightStyle,
    syntaxHighlighting
} from '@codemirror/language'

let view = null;

const autoHeight = {
    "&": {},
    ".cm-scroller": {overflow: "auto"}
};

console.log(tags)
const highlightStyle = HighlightStyle.define([
    {tag: tags.keyword, color: "#cfa757"},
    {tag: tags.comment, color: "#736e64", fontStyle: "italic"},
    {tag: [tags.operator, tags.punctuation, tags.contentSeparator], color: "#828078"},
    {tag: [tags.string, tags.quote], color: "#83a655"},
    {tag: [tags.atom, tags.regexp, tags.link], color: "#4e6773"},
    {tag: [tags.number, tags.bracket, tags.literal, tags.list], color: "#66754b"},
    {tag: tags.name, color: "#857955"},
    {tag: [tags.className, tags.namespace, tags.typeName, tags.heading], color: "#90a35b"},
    {tag: tags.strong, fontWeight: "bold"},
    {tag: tags.emphasis, fontStyle: "italic"},
    {tag: tags.strikethrough, fontStyle: "strikethrough"}
]);
  

const indentIfNoOptions = ({state, dispatch}) => {
    if (state.readOnly) return false;
    if (completionStatus(state)) {
        return acceptCompletion(view)
    }
    return indentMore({state, dispatch});
}

const indentWithTab = {key: "Tab", run: indentIfNoOptions, shift: indentLess}

document.addEventListener("turbo:load", ev => {
    document.querySelectorAll(".code-editor>textarea").forEach(textarea => {
        autoHeight["&"].height = getComputedStyle(textarea).height;

        let codeLang = textarea.getAttribute("data-lang");

        let lang = null;
        if (codeLang == "ruby") {
            lang = StreamLanguage.define(ruby);
        } else if (codeLang == "html") {
            lang = html();
        } else if (codeLang == "markdown") {
            lang = markdown();
        } else {
            lang = StreamLanguage.define(ruby);
        }

        view = new EditorView({
            extensions: [
                basicSetup,
                keymap.of([indentWithTab]),
                lang,
                syntaxHighlighting(defaultHighlightStyle, {fallback: true}), 
                EditorView.theme(autoHeight), 
                syntaxHighlighting(highlightStyle)],
            doc: textarea.value
        });
        
        textarea.parentNode.insertBefore(view.dom, textarea);
        textarea.style.display = "none";
        textarea.form.addEventListener("submit", () => {
          textarea.value = view.state.doc.toString()
        });
    });
});