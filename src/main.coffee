require 'babel-core/register'
require 'babel-polyfill'
import * as basegl from 'basegl'

import {Breadcrumbs}     from 'view/Breadcrumbs'
import {Connection}      from 'view/Connection'
import {ExpressionNode}  from 'view/ExpressionNode'
import {InputNode}       from 'view/InputNode'
import {NodeEditor}      from 'view/NodeEditor'
import {OutputNode}      from 'view/OutputNode'
import {Searcher}        from 'view/Searcher'
import {Slider}          from 'view/Slider'
import {subscribeEvents} from 'view/Component'
import {runPerformance}  from './performance'

export install = (name, fontRootPath = "", callback) ->
    scene = basegl.scene {domElement: name}
    basegl.fontManager.register 'DejaVuSansMono', fontRootPath + 'DejaVuSansMono.ttf'
    basegl.fontManager.load('DejaVuSansMono').then =>
        nodeEditor = new NodeEditor scene
        window.n = nodeEditor
        nodeEditor.initialize()
        callback nodeEditor

export onEvent = subscribeEvents

main = (callback) -> install 'basegl-root', 'rsc/', callback

window.run = main

mkWidget  = (cons, args) -> (parent) -> new cons args, parent

runExample = -> main (nodeEditor) ->
    nodeEditor.setBreadcrumbs new Breadcrumbs
        moduleName: 'Foo'
        items: ['bar', 'baz']

    nodeEditor.setNodes [
        new ExpressionNode
            key: 1
            name: 'number1'
            expression: '12'
            inPorts: [{key: 1, name: 'onlyPort'}]
            outPorts: [{key: 1}
                      ,{key: 2}]
            position: [200, 300]
            expanded: false
            selected: false
            error: true
            value: 'Another error description'
        new ExpressionNode
            key: 2
            name: 'bar'
            inPorts:
                [
                    key: 1
                    name: 'port1'
                ,
                    key: 2
                    name: 'port2'
                ,
                    key: 3
                    name: 'port3'
                ,
                    key: 4
                    name: 'port4'
                ]
            outPorts: [{key: 1}]
            position: [200, 600]
            expanded: false
            selected: false
            value: '54'
        new ExpressionNode
            key: 3
            name: 'baz'
            expression: 'foo bar baz'
            inPorts:
                [
                    key: 1
                    name: 'port1'
                    widgets:
                        [
                            mkWidget Slider,
                                min: 0
                                max: 100
                                value: 49
                        ,
                            mkWidget Slider,
                                min: -50
                                max: 50
                                value: 11
                        ]
                ,
                    key: 2
                    name: 'port2'
                    widgets:
                        [
                            mkWidget Slider,
                                min: -10
                                max: 10
                                value: 5
                        ]
                ,
                    key: 3
                    name: 'port3'
                    widgets:
                        [
                            mkWidget Slider,
                                min: -10
                                max: 10
                                value: 5
                        ,
                            mkWidget Slider,
                                min: -10
                                max: 10
                                value: 5
                        ,
                            mkWidget Slider,
                                min: -10
                                max: 10
                                value: 5
                        ]
                ]
            outPorts: [{key: 1}]
            position: [500, 300]
            expanded: true
            error: true
            value: 'Error description'
            selected: false
        new ExpressionNode
            key: 4
            name: 'node1'
            inPorts: [{key: 1, name: 'onlyPort'}]
            outPorts: [{key: 1}]
            position: [500, 600]
            expanded: false
            selected: false
        ]

    nodeEditor.setInputNode new InputNode
        key: 'in'
        outPorts:
            [
                key: 1
                name: 'a'
            ,
                key: 2
                name: 'b'
            ,
                key: 3
                name: 'c'
            ]
    nodeEditor.setOutputNode new OutputNode
        key: 'out'
        inPorts: [ {key: 1}
                 , {key: 2}]
    nodeEditor.setConnections [
        new Connection
            key: 0
            srcNode: 'in'
            srcPort: 2
            dstNode: 1
            dstPort: 1
        new Connection
            key: 1
            srcNode: 1
            srcPort: 1
            dstNode: 2
            dstPort: 1
        new Connection
            key: 2
            srcNode: 2
            srcPort: 1
            dstNode: 3
            dstPort: 1
        new Connection
            key: 3
            srcNode: 3
            srcPort: 1
            dstNode: 4
            dstPort: 1
        new Connection
            key: 4
            srcNode: 4
            srcPort: 1
            dstNode: 'out'
            dstPort: 2
        ]
    nodeEditor.setSearcher new Searcher
        key: 4
        mode: 'node'
        selected: 0
        entries: [
            name: 'bar'
            doc:  'bar description'
            className: 'Bar'
            highlights:
                [
                    start: 1
                    end: 2
                ]
        ,
            name: 'foo'
            doc:  'foo multiline\ndescription'
            className: 'Foo'
        ,
            name: 'baz'
            doc:  'baz description'
            className: 'Test'
            highlights:
                [
                    start: 1
                    end: 3
                ]
        ]


    subscribeEvents (path, event) =>
        console.warn {path: path, base: event}

if NODE_EDITOR_EXAMPLE? then runExample()
else if NODE_EDITOR_PERFORMANCE? then main runPerformance
