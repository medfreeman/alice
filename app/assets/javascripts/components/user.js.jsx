var User = React.createClass({
  propTypes: {
    role: React.PropTypes.string,
    name: React.PropTypes.string,
    sciper: React.PropTypes.string,
    email: React.PropTypes.string,
    studio: React.PropTypes.string
  },

  render: function() {
    return (
      <Reactable.Tr className="test" data={this.props.user}>
        {this.props.user}
        <Reactable.Td column="Actions">
          <button className="btn btn-primary" onClick={handleDelete}>
            Delete
          </button>
        </Reactable.Td>
      </Reactable.Tr>
    );
  }
});
