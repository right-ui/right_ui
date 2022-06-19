function resizableIframe() {
  return {
    resizing: false,
    init: function () {
      const { iframe } = this.$refs

      const iframeHeight = iframe.contentWindow.bodyHeight
      if (iframeHeight) {
        iframe.style.height = `${iframeHeight}px`
        iframe.style.opacity = 1
      }

      window.addEventListener('message', (e) => {
        const { type, name, height } = e.data

        if (type == 'BODY_HEIGHT' && name == iframe.name) {
          iframe.style.height = `${height}px`
          iframe.style.opacity = 1
        }
      })

      this.onResize = this.onResize.bind(this)
      this.onResizeEnd = this.onResizeEnd.bind(this)
    },
    onResizeStart: function (e) {
      const { root } = this.$refs

      this.resizeStartX = e.pageX
      this.resizeStartWidth = root.clientWidth

      this.resizing = true
      window.addEventListener('pointermove', this.onResize)
      window.addEventListener('pointerup', this.onResizeEnd)
    },
    onResizeEnd: function () {
      const { root } = this.$refs

      this.resizing = false
      window.removeEventListener('pointermove', this.onResize)
      window.removeEventListener('pointerup', this.onResizeEnd)

      if (root.clientWidth === root.parentElement.clientWidth) {
        root.style.width = '100%'
      }
    },
    onResize: function (e) {
      const { root } = this.$refs

      const dx = e.pageX - this.resizeStartX

      const width = Math.round(this.resizeStartWidth + dx)
      root.style.width = `${Math.max(0, width)}px`
    },
  }
}

window.resizableIframe = resizableIframe
