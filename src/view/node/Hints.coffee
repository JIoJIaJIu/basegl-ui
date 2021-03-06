import {Background}       from 'shape/node/Background'
import {FramedText}       from 'widget/FramedText'
import {Widget}           from 'widget/Widget'
import {VerticalLayout}   from 'widget/VerticalLayout'


export class Hints extends Widget
    initModel: =>
        model = super()
        model.entries = []
        model.selected = 0
        model

    prepare: =>
        @addDef 'entries', VerticalLayout,
            width: @style.node_bodyWidth - 2*@style.node_widgetOffset_h
        @addDef 'background', Background,
            width: @style.node_bodyWidth

    update: =>
        if @changed.entries or @changed.selected
            hints = []
            @model.entries.forEach (entry, i) =>
                hints.push
                    cons:       FramedText
                    text:       entry.name
                    color:      [@style.text_color_r, @style.text_color_g, @style.text_color_b]
                    frameColor:
                        if (i == 0) and (@model.selected != 0)
                            [@style.bgColor_h, @style.bgColor_s, @style.bgColor_l]
                        else
                            null
            @updateDef 'entries', children: hints

            @__minHeight = @def('entries').height() + 2*@style.node_widgetOffset_v
            @autoUpdateDef 'background', Background,
                height: @__minHeight
        if @changed.siblings
            @updateDef 'background',
                roundBottom: not @model.siblings.bottom
                roundTop:    not @model.siblings.top

    adjust: =>
        @view('entries').position.xy =
            [@style.node_widgetOffset_h, - @style.node_widgetOffset_v - @style.node_widgetHeight/2]
