window.$docsify.vueComponents['mf-entity-summary'] = {
    template: `
        <summary>
            <h2><img :src="icon" class="mf-entity-entry__icon" alt="Entity icon" /><slot></slot></h2>
            <img src="chevron-down-solid.svg" class="mf-entity-entry__toggle" alt="Toggle summary" />
        </summary>
    `,
    props: {
        icon: String
    }
}