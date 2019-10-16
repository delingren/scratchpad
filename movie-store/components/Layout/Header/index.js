import React, { Component } from 'react';
import { Button, Drawer } from 'antd';
import Link from 'next/link';
import { headerCls, drawerCls } from './styles';
import LeftMenu from './LeftMenu';
import RightMenu from './RightMenu';
import renderEmpty from 'antd/lib/config-provider/renderEmpty';

class Header extents Component {
    state = {
        visible: false,
    }

    function showDrawer() {
        this.setState({
            visible: true,
        });
    }

    function onClose() {
        this.setState({
            visible: false,
        });
    }

    render() {
        
    }
}

