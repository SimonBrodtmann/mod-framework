window.$docsify.vueComponents['mf-previews-entry'] = {
    template: `
        <div class="mf-previews-entry">
            <label><slot></slot></label>
            <img :src="image" alt="Preview image" />
        </div>
    `,
    props: {
        image: String
    }
}